require_dependency 'issue'
require 'active_support/concern'

module RedmineDigest
  module Patches
    module IssuePatch
      extend ActiveSupport::Concern

      included do
        prepend InstanceMethods
      end

      module InstanceMethods
        def recipients
          found_mails = super
          found_users = found_mails.map { |mail| User.find_by_mail(mail) }
          found_users.reject do |found_user|
            found_user.skip_issue_add_notify?(self)
          end.map(&:mail)
        end

        def watcher_recipients
          found_mails = super
          found_watchers = found_mails.map { |mail| User.find_by_mail(mail) }
          found_watchers.reject do |found_watcher|
            found_watcher.skip_issue_add_notify?(self)
          end.map(&:mail)
        end
      end
    end
  end
end
