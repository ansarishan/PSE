ActiveAdmin.register Drug do
  permit_params :brand_name, 
  :drug_company_id, 
  :special_situation

  config.batch_actions = false

  index download_links: false do
    id_column
    column :brand_name
    column :drug_company
    column :generic_name
    column :compound_name
    column :organizations_names do |org|
      org.organizations_names
    end
    actions
  end

  show do |x|
    attributes_table do
      row :id
      row :brand_name
      row :drug_company
      row :generic_name     
      row :organizations_names do |org|
        org.organizations_names
      end
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
      collected_data = Organization.all.map{|x| [x.name, x.id, {checked: f.object.special_situation_array.include?(x.id.to_s)}]}
      f.input :special_situation_array,  as: :check_boxes  , collection: collected_data
    end
    f.actions
  end
  before_save do |model|
    model.special_situation = params[:drug][:special_situation_array].join(',') if params[:drug][:special_situation_array].is_a?(Array)
  end
end
