require 'dedent'

module Brisk
  module Models
    module Mailer extend self
      def user_invite!(invite)
        Mail.deliver do
          from    "#{CONFIG['website_name']} <#{ENV['ADMIN_EMAIL_ADDR']}>"
          to      invite.email
          subject "An invitation to join #{CONFIG['website_name']} from #{invite.user_name}."
          body    <<-EOF.dedent
            Hi there,

            #{invite.user_name} has invited you to join #{CONFIG['website_name']}, an upbeat community.

            To learn more, and claim your invitation, visit:

            \t#{request.base_url}/claim/#{invite.code}

            Thanks,
            Admin
          EOF
        end
      end

      def user_activate!(user)
        Mail.deliver do
          from    "#{CONFIG['website_name']} <#{ENV['ADMIN_EMAIL_ADDR']}>"
          to      user.email
          subject "Welcome to #{CONFIG['website_name']}!"
          body    <<-EOF.dedent
            Hi there,

            Good news! #{user.parent_name || 'Admin'} has activated your #{CONFIG['website_name']} account.

            Thanks,
            Admin
          EOF
        end
      end

      def feedback!(settings, text, email = nil)
        Mail.deliver do
          from    "#{ENV['SYSTEM_EMAIL_NAME']} <#{ENV['SYSTEM_EMAIL_ADDR']}>"
          to      ENV['ADMIN_EMAIL_ADDR']
          subject "#{settings.website_name} Feedback"
          reply_to email if email.present?
          body     text

          charset = 'UTF-8'
          content_transfer_encoding = '8bit'
        end
      end
    end
  end
end
