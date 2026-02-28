require 'redmine'

Rails.application.paths['app/overrides'] ||= []
Rails.application.paths['app/overrides'] << File.expand_path('../app/overrides', __FILE__)

Redmine::Plugin.register :redmine_digest do
  name 'Redmine Digest Plugin'
  description 'This plugin enables you to send daily/weekly/monthly digests.'
  author 'Restream'
  version '1.1.0'
  url 'https://github.com/Restream/redmine_digest'

  requires_redmine version_or_higher: '2.2'
  requires_redmine_plugin :redmine__select2, version_or_higher: '1.0.1'

  permission :manage_digest_rules, { digest_rules: [:new, :create, :edit, :update] },
             public:  true,
             require: :loggedin
end


plugin_lib_path = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(plugin_lib_path) unless $LOAD_PATH.include?(plugin_lib_path)

require 'redmine_digest'
