class WormholeEffect
  def initialize(name, wh_class)
    @name = name
    @wh_class = wh_class
  end

  def effects
    return [] if @name.nil?
    send("effect_#{@name.downcase.gsub(" ", "_")}".to_sym)
  end

  private

  def effect_cataclysmic_variable
    [
      { name: "Local Armor Repair Amount", effect: "-#{base15}%", good: false },
      { name: "Local Shield Boost Amount", effect: "-#{base15}%", good: false },
      { name: "Shield Transfer Amount",    effect: "+#{base30}%", good: true },
      { name: "Remote Repair Amount",      effect: "+#{base30}%", good: true },
      { name: "Capacitor Capacity",        effect: "+#{base30}%", good: true },
      { name: "Capacitor Recharge Time",   effect: "+#{base15}%", good: false },
      { name: "Remote Cap Transfer Amount",effect: "-#{base15}%", good: false }
    ]
  end

  def effect_magnetar
    [
      { name: "Damage",                   effect: "+#{base30}%", good: true },
      { name: "Missile Explosion Radius", effect: "+#{base15}%", good: false },
      { name: "Drone Tracking",           effect: "-#{base15}%", good: false },
      { name: "Targeting Range",          effect: "-#{base15}%", good: false },
      { name: "Tracking Speed",           effect: "-#{base15}%", good: false },
      { name: "Target Painter Strength",  effect: "-#{base15}%", good: false }
    ]
  end

  def effect_black_hole
    [
      { name: "Missile Velocity",          effect: "+#{base15}%", good: true },
      { name: "Missile Explosion Velocity",effect: "+#{base30}%", good: true },
      { name: "Ship Velocity",             effect: "+#{base30}%", good: true },
      { name: "Stasis Webifier Strength",  effect: "-#{base15}%", good: false },
      { name: "Inertia",                   effect: "+#{base15}%", good: false },
      { name: "Targeting Range",           effect: "+#{base30}%", good: true }
    ]
  end

  def effect_pulsar
    [
      { name: "Shield HP",               effect: "+#{base30}%", good: true },
      { name: "Armor Resists",           effect: "-#{base15}%", good: false },
      { name: "Capacitor Recharge",      effect: "-#{base15}%", good: true },
      { name: "Signature Radius",        effect: "+#{base30}%", good: false },
      { name: "NOS / Neut Drain Amount", effect: "+#{base30}%", good: true }
    ]
  end

  def effect_wolf_rayet
    [
      { name: "Armor HP",            effect: "+#{base30}%", good: true },
      { name: "Shield Resists",      effect: "-#{base15}%", good: false },
      { name: "Small Weapon Damage", effect: "+#{base60}%", good: true },
      { name: "Signature Radius",    effect: "-#{base15}%", good: true }
    ]
  end

  def effect_red_giant
    [
      { name: "Heat Damage",       effect: "+#{base15}%", good: false },
      { name: "Overload Bonus",    effect: "+#{base30}%", good: true },
      { name: "Smart Bomb Range",  effect: "+#{base30}%", good: true },
      { name: "Smart Bomb Damage", effect: "+#{base30}%", good: true },
      { name: "Bomb Damage",       effect: "+#{base30}%", good: true }
    ]
  end

  def base30
    @base30 ||= @wh_class * 14 + 30
  end

  def base15
    @base15 ||= @wh_class * 7 + 15
  end

  def base60
    @base60 ||= @wh_class * 28 + 60
  end
end
