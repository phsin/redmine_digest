module RedmineDigest
  class DigestError < RuntimeError
  end
end

require 'active_support/reloader'
require_dependency 'redmine_digest/patches/project_patch'
require_dependency 'redmine_digest/patches/user_patch'
require_dependency 'redmine_digest/patches/my_controller_patch'
require_dependency 'redmine_digest/patches/issue_patch'
require_dependency 'redmine_digest/patches/journal_patch'
require_dependency 'redmine_digest/hooks/my_account_hook'

def apply_redmine_digest_patches
  if defined?(Project) && !Project.included_modules.include?(RedmineDigest::Patches::ProjectPatch)
    Project.send :include, RedmineDigest::Patches::ProjectPatch
  end

  if defined?(User) && !User.included_modules.include?(RedmineDigest::Patches::UserPatch)
    User.send :include, RedmineDigest::Patches::UserPatch
  end

  if defined?(MyController) && !MyController.included_modules.include?(RedmineDigest::Patches::MyControllerPatch)
    MyController.send :include, RedmineDigest::Patches::MyControllerPatch
  end

  if defined?(Issue) && !Issue.included_modules.include?(RedmineDigest::Patches::IssuePatch)
    Issue.send :include, RedmineDigest::Patches::IssuePatch
  end

  if defined?(Journal) && !Journal.included_modules.include?(RedmineDigest::Patches::JournalPatch)
    Journal.send :include, RedmineDigest::Patches::JournalPatch
  end
end

apply_redmine_digest_patches

ActiveSupport::Reloader.to_prepare do
  apply_redmine_digest_patches
end

