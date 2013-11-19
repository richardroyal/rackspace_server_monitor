class Setting < ActiveRecord::Base
  
  # Config
  attr_accessible :key, :value
  
  # Validations
  validates :key, :presence => true
  validates_uniqueness_of :key

  # Get a settings value by key and create if does not exist.
  def self.get_setting( key, default="not setup", value_only=true )
    if key
      s = Setting.where( :key => key ).first
      if s.blank?
        s = Setting.create( :key => key, :value => default )
      end

      if value_only
        return s.value
      else
        s
      end
    end
  end

end
