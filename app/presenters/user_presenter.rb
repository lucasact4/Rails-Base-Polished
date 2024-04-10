class UserPresenter < ApplicationPresenter

  def roles
      super.map{|e|I18n.t("activerecord.attributes.user_role.roles.#{e.role}")}.join(', ')
  end

  def last_sign_in_at
      I18n.l(super) if super.present?
  end

end