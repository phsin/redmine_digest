module RedmineDigest
  module Hooks
    class MyAccountHook < Redmine::Hook::ViewListener
      def view_my_account_preferences(context = {})
        context[:controller].send(:render_to_string, partial: 'digest_rules/index', locals: { user: context[:user] })
      end

      def view_users_form(context = {})
        user = context[:user]
        return ''.html_safe if user.blank? || user.new_record?
        return ''.html_safe unless User.current.admin? || User.current == user

        context[:controller].send(:render_to_string, partial: 'digest_rules/index', locals: { user: user })
      end
    end
  end
end
