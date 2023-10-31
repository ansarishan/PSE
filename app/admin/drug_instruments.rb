ActiveAdmin.register DrugInstrument do
  permit_params :drug_period_id,
    :up_leverage_factor, :down_leverage_factor,
    :up_return_cap, :down_return_cap,
    :net_revenue_projection,
    :label, :source, :notes

  config.batch_actions = false

  index download_links: false do
    id_column
    column('Drug') {|di| di.drug_period.drug }
    column :label
    column :drug_period
    column(:up_leverage_factor) {|di| "#{di.up_leverage_factor}x" }
    column(:up_return_cap) {|di| "#{di.up_return_cap}%" }
    column :net_revenue_projection
    column(:down_return_cap) {|di| "#{di.down_return_cap}%" }
    column(:down_leverage_factor) {|di| "#{di.down_leverage_factor}x" }
    column(:notes)
    actions
  end

  show do |x|
    attributes_table do
      row :id
      row('Drug') {|di| di.drug_period.drug }
      row :label
      row :source
      row :drug_period
      row(:up_leverage_factor) {|di| "#{di.up_leverage_factor}x" }
      row(:up_return_cap) {|di| "#{di.up_return_cap}%" }
      row :net_revenue_projection
      row(:down_return_cap) {|di| "#{di.down_return_cap}%" }
      row(:down_leverage_factor) {|di| "#{di.down_leverage_factor}x" }
      row :notes
    end
  end

  form do |f|
    #f.semantic_errors(*f.object.errors.keys)
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.li "<label class='label'>Drug</label><span>#{f.object.drug_period.nil? ? 'unspecified' : f.object.drug_period.drug.brand_name}</span>".html_safe
      f.input :label
      f.input :source
      f.input :drug_period
      f.input :up_leverage_factor, hint: 'integer; is a multiplier', min: 0
      f.input :up_return_cap, hint: 'a percent value expressed in integer', min: 0
      f.input :net_revenue_projection, hint: 'decimal (in millions, e.g. "8.5" means 8.5 MM)', min: 0
      f.input :down_return_cap, hint: 'a percent value expressed in integer', min: 0
      f.input :down_leverage_factor, hint: 'integer; is a multiplier', min: 0
      f.input :notes
    end
    f.actions
  end
end
