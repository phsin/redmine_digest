puts "LOADING PATCH my_account_patch.rb"

module RedmineDigest
  module Patches
    module MyAccountPatch
      Deface::Override.new(
        virtual_path: 'my/account',
        name:         'my_digest_rules',
        insert_after: 'div.splitcontentright fieldset.box:first-child',
        text:         '<%= render "digest_rules/index" %>'
      )
    end
  end
end

