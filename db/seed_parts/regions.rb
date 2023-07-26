Region::VALID_NAMES.each do |name|
  Region.find_or_create_by!(name: name)
end

unless Region::VALID_NAMES.include?('USA')
  raise 'Looks like Region::VALID_NAMES changed. Please update the seed to use a valid region.'
end
