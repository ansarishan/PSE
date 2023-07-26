module SidemenuHelper
  def sidemenu_trail(drug_period)
    return [nil,nil,nil,nil,nil] unless drug_period
    trail = drug_period.menu_trail
    [trail[:region].id,
      trail[:company].id,
      trail[:drug].id,
      trail[:period].period_type,
      trail[:period].id
    ]
  end

  def sidemenu_open_close_state(id1, id2)
    return 'closed' unless (id1 && id2)
    id1==id2 ? 'open' : 'closed'
  end

end
