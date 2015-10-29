class HashAttrs
  def initialize(attributes = {})
    @attributes = {
      :repeat_start_date => nil,
      :repeat_interval => nil,
      :repeat_year => nil,
      :repeat_month => nil,
      :repeat_day_of_month => nil,
      :repeat_day_of_week => nil,
      :repeat_week => nil,
      :repeat_hour => 0,
      :repeat_minute => 0,
      :repeat_until => nil
    }.merge(attributes)
  end

  def method_missing(m, *args, &_block)
    if m =~ /[a-z_]+=/
      attribute = m.to_s.strip.chop.to_sym
      return @attributes[attribute] = args[0] if @attributes.key?(attribute)
    else
      return @attributes[m] if @attributes.key?(m)
    end

    fail ArgumentError, "Method `#{m}` doesn't exist."
  end

  def respond_to?(name, _include_private = false)
    return true if @attributes.key?(name)

    super
  end
end
