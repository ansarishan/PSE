require './db/seed_parts/admin'
require './db/seed_parts/pill_player'
require './db/seed_parts/chem_bettor'
require './db/seed_parts/regions'
if Rails.env.development? || Rails.env.test?
  require './db/seed_parts/drugs'
end
