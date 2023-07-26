ActiveAdmin.register OnboardingInvite do
  permit_params :url_code, :email, :user_id

  config.batch_actions = false

  index download_links: false do
    id_column
    column :email
    column :url_code
    column :user
    actions
  end

  show do |x|
    attributes_table do
      row :id
      row :email
      row :url_code
      row :user
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    #f.semantic_errors(*f.object.errors.keys)
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :email
      f.input :url_code
    end
    f.actions
  end
end
