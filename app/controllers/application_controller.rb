require "application_responder"

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :set_current_organisation

  before_action { @admin = true }
  # check_authorization unless: :devise_controller? TODO enable this line when authorization is implemented

  before_action :set_locale
  before_action :load_organisation

  add_flash_types :warning

  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
  
  def after_sign_in_path_for(resource_or_scope)
    home_index_path
  end

  def load_organisation
    @organisation = Organisation.find(params[:organisation_id]) if params[:organisation_id].present?
  end

  def set_organisation
    sel_organisation = current_user.organisations.find(params[:organisation_id]);
    if sel_organisation.present?
      session[:current_organisation_id] = sel_organisation.id
      @current_organisation = sel_organisation
    end
    redirect_to :root
  end

  def set_current_user
    User.current = current_user
  end

  def set_current_organisation
    Organisation.current = current_organisation
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def current_organisation
    if @current_organisation.nil? && current_user.present?
      if session[:current_organisation_id].present? && (selected_organisation = current_user.organisations.where(id: session[:current_organisation_id]).first)
        @current_organisation = selected_organisation
      else
        @current_organisation = current_user.organisations.first
      end
    end
    @current_organisation
  end
  helper_method :current_organisation

  @current_menu_category = nil
  def current_menu_category
    if @current_menu_category.present?
      @current_menu_category
    else
      nil # We let the menu view determine the current main category based on the current sub category.
    end
  end
  attr_writer :current_menu_category
  helper_method :current_menu_category

  @current_menu_sub_category = nil
  def current_menu_sub_category
    if @current_menu_sub_category.present?
      @current_menu_sub_category
    else
      controller_name.to_sym
    end
  end
  helper_method :current_menu_sub_category

  @current_menu_link = nil
  def current_menu_link
    if @current_menu_link.present?
      @current_menu_link
    else
      action_name.to_sym
    end
  end
  helper_method :current_menu_link
end
