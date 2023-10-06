# app/admin/inputs/custom_multi_select_input.rb
class CustomMultiSelectInput < Formtastic::Inputs::StringInput
    def to_s
      # Join the selected values with commas and set the value of the input field
      object.send(method).join(', ')
    end
  
    def input_html_options
      super.merge({ value: to_s })
    end
  end