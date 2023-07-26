ActiveAdmin.register User do
  permit_params :email, :username, :onboarded, :role,
    :organization_id, :first_name, :last_name, :phone,
    :legal_is_separate, :has_signed_eula,
    :password, :password_confirmation

  config.batch_actions = false

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end

  index download_links: false do
    id_column
    column :username
    column :email
    column :onboarded
    column :role
    column :organization
    column :first_name
    column :last_name
    actions
  end

  show do |x|
    attributes_table do
      row :id
      row :username
      row :role
      row :email
      row :first_name
      row :last_name
      row :onboarded
      row :organization
      row :phone
      row :has_signed_eula
      row :legal_is_separate
      row :created_at
      row :updated_at
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
    end
  end

  form do |f|
    #f.semantic_errors(*f.object.errors.keys)
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :username
      f.input :role
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :onboarded
      f.input :organization
      f.input :phone
      f.input :has_signed_eula
      f.input :legal_is_separate
      f.input :password, hint: "Leave blank if you are not changing it."
      f.input :password_confirmation
    end
    f.actions
  end
end
