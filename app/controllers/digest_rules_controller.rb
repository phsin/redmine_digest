class DigestRulesController < ApplicationController

  PREVIEW_ISSUE_LIMIT = 20

  before_action :set_user_from_params
  before_action :set_digest_rule, only: [:edit, :update, :destroy, :show]
  before_action :set_user_from_digest_rule, only: [:edit, :update, :destroy, :show]
  before_action :authorize_digest_rule_access

  def new
    @digest_rule = @user.digest_rules.build
  end

  def create
    @digest_rule = @user.digest_rules.build(digest_rule_params)
    if @digest_rule.save
      redirect_to return_path
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @digest_rule.update(digest_rule_params)
      redirect_to return_path
    else
      render action: 'edit'
    end
  end

  def destroy
    @digest_rule.destroy
    redirect_to return_path
  end

  def show
    @digest = RedmineDigest::Digest.new(@digest_rule, Time.now, PREVIEW_ISSUE_LIMIT)
    render layout: 'digest'
  end

  private

  def set_user_from_params
    @user = params[:user_id].present? ? User.find(params[:user_id]) : User.current
  end

  def set_digest_rule
    @digest_rule = DigestRule.find(params[:id])
  end

  def set_user_from_digest_rule
    @user = @digest_rule.user
  end

  def authorize_digest_rule_access
    deny_access unless User.current.admin? || User.current == @user
  end

  def return_path
    if User.current.admin? && @user != User.current
      edit_user_path(@user)
    else
      { controller: 'my', action: 'account' }
    end
  end

  def digest_rule_params
    params.require(:digest_rule).permit(
      :active,
      :name,
      :raw_project_ids,
      :project_selector,
      :notify,
      :recurrent,
      :template,
      event_ids: []
    )
  end

end
