# frozen_string_literal: true
class BaseAdminController < GenericController
  include SidebarConcerns
  set_current_tenant_through_filter

  before_action :_set_show_sidebar
  before_action :_set_show_header
  before_action :_set_is_popup
  before_action :authenticate_user!

  before_action :set_tenant
  before_action :authenticate_user_tenant
  
  before_action :set_menu
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index
  layout "layouts/admin/application"

  def redirect_to_index
    "admin_#{super}"
	end

	def redirect_to_instance
    "admin_#{super}"
  end

  def set_tenant
    session_service = SessionService.new(request)
    unless current_user.admin?
      set_current_tenant(current_user.tenant) if current_user.tenant.present?
    else
      if session_service.admin_tenant_id.present?
        set_current_tenant( Tenant.find_by!(id: session[:admin_tenant_id]))
      end
    end
  end
  
  def authenticate_user_tenant
    unless current_user.admin?
      raise ActiveRecord::RecordInvalid if current_tenant.present? and current_tenant.id != current_user.tenant_id
    end 
  end

  def hide_sidebar
    @show_sidebar = false
  end
  
  
  def hide_header
    @show_header = false
  end
  
  private
  def _set_show_sidebar
    @show_sidebar = true 
  end
  
  def _set_show_header
    @show_header = true
  end
  
  def _set_is_popup
    if params.has_key?('popup') and params['popup'] == 'true'
      hide_sidebar
      hide_header
    end
  end

  
end
