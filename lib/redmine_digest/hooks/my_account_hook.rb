module RedmineDigest
  module Hooks
    class MyAccountHook < Redmine::Hook::ViewListener
      def view_my_account_preferences(context = {})
        context[:controller].send(:render_to_string, partial: 'digest_rules/index', locals: { user: context[:user] })
      end
    end
  end
end
