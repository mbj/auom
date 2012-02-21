module SUnits
  class Unit
    include Virtus::ValueObject

    attribute :scalar,       Rational, :writer => :protected, :reader => :public
    attribute :numerators,   Array,    :writer => :protected, :reader => :public
    attribute :denominators, Array,    :writer => :protected, :reader => :public

    # TODO: Make configurable
    def self.units
      @units ||= {
        :none =>      [1],
        :item =>      [1,:item],
        :liter =>     [1,:liter],
        :pack =>      [1,:pack],
        :can =>       [1,:can],
        :kilogramm => [1,:kilogramm],
        :euro =>      [1,:euro],
        :meter =>     [1,:meter],
        :kilometer => [1000,:meter]
      }
    end

    def initialize(*arguments)
      scalar,numerators,denominators = Helper.extract_options(arguments)
      self.scalar = scalar.freeze

      unless @scalar.kind_of?(::Rational)
        raise ArgumentError,"cannot convert: #{scalar.inspect} into Rational"
      end

      numerators =   [*numerators]
      denominators = [*denominators]

      numerators.map! do |numerator|
        unit_scale,numerator = Helper.find_unit(numerator)
        @scalar *= unit_scale
        numerator
      end

      denominators.map! do |denominator|
        unit_scale,denominator = Helper.find_unit(denominator)
        @scalar /= unit_scale
        denominator
      end

      # This nukes units that cancel out with other unit in numerator or denominator 
      numerators   = numerators.  delete_if { |numerator  | denominators.delete_at(denominators.index(numerator)   || denominators.length) }
      denominators = denominators.delete_if { |denominator| numerators.  delete_at(numerators.  index(denominator) || numerators.  length) }

      # Symbol#<=> is only present on mri 1.9

      self.numerators   = numerators.  sort.freeze
      self.denominators = denominators.sort.freeze


      freeze
    end

    def to_hash
      hash = {}
      hash[:scalar] = [scalar.numerator,scalar.denominator]
      hash[:value]  = fractions? ? @scalar.to_f : @scalar.to_i
      hash[:numerators] = @numerators unless @numerators.empty?
      hash[:denominators] = @denominators unless @denominators.empty?
      hash
    end

    def fractions?
      !(@scalar.numerator % @scalar.denominator).zero?
    end

    def pretty_scalar
      unless fractions?
        @scalar.to_i
      else
        '~%0.4f' % @scalar.to_f
      end
    end

    def unit
      [@numerators,@denominators].freeze
    end

    def pretty_unit
      numerator = Helper.prettify_unit_part(@numerators)
      numerator = '1' if numerator.empty?
      denominator = Helper.prettify_unit_part(@denominators)
      denominator = '1' if denominator.empty?
      unless numerator == denominator
        "%s/%s" % [numerator,denominator]
      else
        ''
      end
    end


    def inspect
      pretty_unit = self.pretty_unit

      unit_fmt = pretty_unit.empty? ? '%s' : ' %s'

      "<%s @scalar=%s#{unit_fmt}>" % 
        [self.class.name,pretty_scalar,pretty_unit]
    end

    def +(operand)
      operand = self.class.convert operand

      unless operand.unit == self.unit
        raise ArgumentError,'cannot add incompatible units'
      end

      self.class.new(
        operand.scalar + @scalar,
        numerators.dup,
        denominators.dup
      )
    end

    def -(operand)
      self.+(self.class.convert(operand) * -1)
    end

    def *(operand)
      operand = self.class.convert operand
      self.class.new(
        operand.scalar * @scalar,
        numerators + operand.numerators,
        denominators + operand.denominators
      )
    end

    def /(operand)
      operand = self.class.convert operand
      self * self.class.new(
        1 / operand.scalar,
        operand.denominators.dup,
        operand.numerators.dup
      )
    end

    def ==(operand)
      operand = self.class.convert operand
      operand.scalar == @scalar && operand.unit == self.unit
    end

    def unitless?
      @numerators.empty? and @denominators.empty?
    end

    # Can I use Virtus coercion framework here?
    # True, but should I?
    def self.convert(operand)
      case operand
      when self
        operand
      when Fixnum
        self.new(operand)
      when Rational
        self.new(operand)
      else
        raise ArgumentError,"+operand+ must be kind of Unit, Rational or Fixnum was #{operand.class}"
      end
    end
  end
end
