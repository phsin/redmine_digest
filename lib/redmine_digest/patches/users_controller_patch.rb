require_dependency 'users_controller'

module RedmineDigest
  module Patches
    module UsersControllerPatch
      extend ActiveSupport::Concern

      included do
        before_action :toggle_digest_rules, only: [:update], if: -> { params[:digest_rules].present? }
      end

      def toggle_digest_rules
        user = @user || User.find_by(id: params[:id])
        return true unless user
        return true unless User.current.admin? || User.current == user

        digest_rules = params.delete(:digest_rules)
        active_ids = Array(digest_rules[:active_ids])

        user.digest_rules.each do |digest_rule|
          digest_rule.active = active_ids.include?(digest_rule.id.to_s)
          digest_rule.save
        end
        true
      end
    end
  end
end
