module AUOM
  # A scalar with units
  class Unit
    include Equalizer.new(:scalar, :numerators, :denominators)
    include Algebra
    include Equalization
    include Inspection
    include Relational

    # Return scalar
    #
    # @example
    #
    #   include AUOM
    #   m = Unit.new(1, :meter)
    #   m.scalar # => Rational(1, 1)
    #
    # @return [Rational]
    #
    # @api public
    #
    attr_reader :scalar

    # Return numerators
    #
    # @example
    #
    #   include AUOM
    #   m = Unit.new(1, :meter)
    #   m.numerators # => [:meter]
    #
    # @return [Rational]
    #
    # @api public
    #
    attr_reader :numerators

    # Return denominators
    #
    # @example
    #
    #   include AUOM
    #   m = Unit.new(1, :meter)
    #   m.denoninators # => []
    #
    # @return [Rational]
    #
    # @api public
    #
    attr_reader :denominators

    # Return unit descriptor
    #
    # @return [Array]
    #
    # @api public
    #
    # @example
    #
    #   u = Unit.new(1, [:meter, :meter], :euro)
    #   u.unit # => [[:meter, :meter], [:euro]]
    #
    attr_reader :unit

    # These constants can easily be changed
    # by an application specific subclass that overrides
    # AUOM::Unit.units with an own hash!
    UNITS = {
      :item =>      [1, :item],
      :liter =>     [1, :liter],
      :pack =>      [1, :pack],
      :can =>       [1, :can],
      :kilogramm => [1, :kilogramm],
      :euro =>      [1, :euro],
      :meter =>     [1, :meter],
      :kilometer => [1000, :meter]
    }.freeze

    # Return buildin units symbols
    #
    # @return [Hash]
    #
    # @api private
    #
    def self.units
      UNITS
    end

    # Check for unitless unit
    #
    # @return [true]
    #   return true if unit is unitless
    #
    # @return [false]
    #   return false if unit is NOT unitless
    #
    # @example
    #
    #   Unit.new(1).unitless?         # => true
    #   Unit.new(1, :meter).unitless ? # => false
    #
    # @api public
    #
    def unitless?
      numerators.empty? and denominators.empty?
    end

    # Test if units are the same
    #
    # @param [Unit] other
    #
    # @return [true]
    #   if units are the same
    #
    # @return [false]
    #   otehrwise
    #
    # @example
    #
    #   a = Unit.new(1)
    #   b = Unit.new(1, :euro)
    #   c = Unit.new(2, :euro)
    #
    #   a.same_unit?(b) # => false
    #   b.same_unit?(c) # => true
    #
    # @api public
    #
    def same_unit?(other)
      other.unit.eql?(unit)
    end

    # Instancitate a new unit
    #
    # @param [Rational] scalar
    # @param [Enumerable] numerators
    # @param [Enumerable] denominators
    #
    # @return [Unit]
    #
    # @example
    #
    #   # A unitless unit
    #   u = Unit.new(1)
    #   u.unitless? # => true
    #   u.scalar    # => Rational(1, 1)
    #
    #   # A unitless unit from string
    #   u = Unit.new('1.5')
    #   u.unitless? # => true
    #   u.scalar    # => Rational(3, 2)
    #
    #   # A simple unit
    #   u = Unit.new(1, :meter)
    #   u.unitless?  # => false
    #   u.numerators # => [:meter]
    #   u.scalar     # => Rational(1, 1)
    #
    #   # A complex unit
    #   u = Unit.new(Rational(1, 3), :euro, :meter)
    #   u.fractions? # => true
    #   u.sclar      # => Rational(1, 3)
    #   u.inspect    # => <AUOM::Unit @scalar=~0.3333 euro/meter>
    #   u.unit       # => [[:euro], [:meter]]
    #
    # @api public
    #
    # TODO: Move defaults coercions etc to .build method
    #
    def self.new(scalar, numerators=nil, denominators=nil)
      scalar = rational(scalar)

      scalar, numerators   = resolve([*numerators], scalar, :*)
      scalar, denominators = resolve([*denominators], scalar, :/)

      # sorting on #to_s as Symbol#<=> is not present on 1.8.7
      super(scalar, *[numerators, denominators].map { |base| base.sort_by(&:to_s) }).freeze
    end

    # Assert units are the same
    #
    # @param [Unit] other
    #
    # @return [self]
    #
    # @api private
    #
    def assert_same_unit(other)
      unless same_unit?(other)
        raise ArgumentError, 'Incompatible units'
      end

      self
    end

    # Return converted operand or raise error
    #
    # @param [Object] operand
    #
    # @return [Unit]
    #
    # @raise [ArgumentError]
    #   raises argument error in case operand cannot be converted
    #
    # @api private
    #
    def self.convert(operand)
      converted = try_convert(operand)
      unless converted
        raise ArgumentError, "Cannot convert #{operand.inspect} to #{self}"
      end
      converted
    end

    # Return converted operand or nil
    #
    # @param [Object] operand
    #
    # @return [Unit]
    #   return unit in case operand can be converted
    #
    # @return [nil]
    #   return nil in case operand can NOT be converted
    #
    # @api private
    #
    def self.try_convert(operand)
      case operand
      when self
        operand
      when Fixnum, Rational
        new(operand)
      end
    end


  private

    # Initialize unit
    #
    # @param [Rational] scalar
    # @param [Enumerable] numerators
    # @param [Enumerable] denominators
    #
    # @api private
    #
    def initialize(scalar, numerators, denominators)
      @scalar = scalar

      [numerators, denominators].permutation do |left, right|
        left.delete_if { |item| right.delete_at(right.index(item) || right.length) }
      end

      @numerators = numerators.freeze
      @denominators = denominators.freeze

      @unit = [@numerators, @denominators].freeze
      @scalar.freeze
    end

    # Return rational converted from value
    #
    # @param [Object] value
    #
    # @return [Rationa]
    #
    # @raise [ArgumentError]
    #   raises argument error when cannot be converted to a rational
    #
    # @api private
    #
    def self.rational(value)
      case value
      when Rational
        value
      when Fixnum
        Rational(value)
      else
        raise ArgumentError, "#{value.inspect} cannot be converted to rational"
      end
    end

    private_class_method :rational

    # Resolve unit component
    #
    # @param [Enumerable] components
    # @param [Symbol] operation
    #
    # @return [Array]
    #
    # @api private
    #
    def self.resolve(components, scalar, operation)
      resolved = components.map do |component|
        scale, component = lookup(component)
        scalar = scalar.public_send(operation, scale)
        component
      end
      [scalar, resolved]
    end

    private_class_method :resolve

    # Return unit information
    #
    # @param [Symbol] value
    #   the unit to search for
    #
    # @return [Array]
    #
    # @api private
    #
    def self.lookup(value)
      units.fetch(value) do
        raise ArgumentError, "Unknown unit #{value.inspect}"
      end
    end

    private_class_method :lookup

  end # Unit
end # AUOM
