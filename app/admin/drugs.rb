ActiveAdmin.register Drug do
  permit_params :brand_name, :drug_company_id

  config.batch_actions = false

  index download_links: false do
    id_column
    column :brand_name
    column :drug_company
    column :generic_name
    column :compound_name
    actions
  end

  show do |x|
    attributes_table do
      row :id
      row :brand_name
      row :drug_company
      row :generic_name
      row :compound_name
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    #f.semantic_errors(*f.object.errors.keys)
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :brand_name
      f.input :drug_company
      f.input :generic_name
      f.input :compound_name
    end
    f.actions
  end
end
