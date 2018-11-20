# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class LibLynx < OmniAuth::Strategies::OAuth2
      class NoAccountInfo < StandardError
        def message
          'Failed to obtain the account info'
        end
      end

      class NoInstitution < StandardError
        def message
          'The given email domain is not registered with any of the supported institutions'
        end
      end

      option :client_options,
        site: 'https://connect.liblynx.com',
        token_url: '/oauth/v2/token',
        client_options: {
          auth_scheme: :basic_auth
        }

      option :id_url, 'https://connect.liblynx.com/api/identifications'

      def callback_url
        options[:callback_url] || (full_host + script_name + callback_path)
      end

      uid { raw_info['id'] }

      info do
        i = raw_info['individual'] || {}
        {
          'email' => id_body[:email],
          'institution' => request.params['institution'],
          'reference' => raw_info['reference'],
          'name' => i['display_name'],
          'surname' => i['surname'],
          'given_name' => i['given_name'],
          'raw' => raw_info['_response'],
          'attributes' => raw_info.dig('_response', 'raw_attr')
        }
      end

      def request_phase
        res = access_token
          .request(:post, options.id_url, body: id_body)
          .parsed
        if id_body[:email].present?
          institution = res['user_institution']
          return fail!(:no_institution, NoInstitution.new) unless institution
          log(:info, "User institution: #{institution}")
        end
        id = res['id']
        url = URI.join(callback_url, "?email=#{id_body[:email]}&institution=#{institution['account_name']}").to_s
        hmac = OpenSSL::HMAC.hexdigest('SHA256', client.secret, url)
        redirect("#{client.site}/wayf/#{id}?url=#{CGI.escape(url)}&hash=#{hmac}")
      end

      def raw_info
        @raw_info ||= begin
          r = access_token
            .request(:post, options.id_url, body: id_body.merge(url: @auth_url))
            .parsed
          ref = r.dig('account', 'publisher_reference')
          {
            '_response' => r,
            'reference' => ref
          }
            .compact
            .merge(r['account_individual'] || {})
        end
      end

      def callback_phase
        @auth_url = [
          id_body[:url],
          '?',
          URI.encode_www_form(request.params)
        ].join
        return fail!(:no_account_info, NoAccountInfo.new) if raw_info.blank?
        env['omniauth.auth'] = auth_hash
        call_app!
      end

      def access_token
        @access_token ||= client.client_credentials.get_token
        @access_token = @access_token.refresh! if @access_token.expired?
        @access_token
      end

      private

      def id_body
        {
          ip: request.ip,
          url: request.params['url'] || callback_url,
          user_agent: request.user_agent,
          email: request.params['email'],
          forceSsoLogin: request.params['force_sso_login']
        }.compact
      end
    end
  end
end

OmniAuth.config.add_camelization('liblynx', 'LibLynx')
