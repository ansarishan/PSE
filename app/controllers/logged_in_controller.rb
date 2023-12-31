class LoggedInController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :set_header_menu

  private

  def set_header_menu
    @header_menu_items = []
    @header_menu_items << { text: 'Dashboard', url: dashboard_path }
      if Region.drug_companies_ss(current_user.organization_id)
        unless current_user.admin? || current_user.organization.ss_link.blank?
          @header_menu_items << { text: 'Doc', url: current_user.organization.ss_link, target: '_blank' }
        end
      end
    
      if current_user.admin?
      @header_menu_items << { text: 'Markets', url: contracts_admin_path }
      @header_menu_items << { text: 'User list', url: userlist_path }
      @header_menu_items << { text: 'Invites', url: invites_path }
      @header_menu_items << { text: 'ActiveAdmin', url: admin_root_path }
    end
  end
end
