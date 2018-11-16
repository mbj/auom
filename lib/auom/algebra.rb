# frozen_string_literal: true

module AUOM
  # The AUOM algebra
  module Algebra
    # Return addition result
    #
    # @param [Object] other
    #
    # @return [Unit]
    #
    # @example
    #
    #   # unitless
    #   Unit.new(1) + Unit.new(2) # => <Unit @scalar=3>
    #
    #   # with unit
    #   Unit.new(1,:meter) + Unit.new(2,:meter) # => <AUOM::Unit @scalar=3 meter>
    #
    #   # incompatible unit
    #   Unit.new(1,:meter) + Unit.new(2,:euro) # raises ArgumentError!
    #
    # @api public
    #
    def +(other)
      klass = self.class
      other = klass.convert(other)
      assert_same_unit(other)
      klass.new(other.scalar + scalar, numerators, denominators)
    end

    # Return subtraction result
    #
    # @param [Object] other
    #
    # @return [Unit]
    #
    # @example
    #
    #   # unitless
    #   Unit.new(2) - Unit.new(1) # => <Unit @scalar=1>
    #
    #   # with unit
    #   Unit.new(2,:meter) - Unit.new(1,:meter) # => <AUOM::Unit @scalar=1 meter>
    #
    #   # incompatible unit
    #   Unit.new(2,:meter) - Unit.new(1,:euro) # raises ArgumentError!
    #
    # @api public
    #
    def -(other)
      self + (other * -1)
    end

    # Return multiplication result
    #
    # @param [Object] other
    #
    # @return [Unit]
    #
    # @example
    #
    #   # unitless
    #   Unit.new(2) * Unit.new(1) # => <Unit @scalar=2>
    #
    #   # with unit
    #   Unit.new(2, :meter) * Unit.new(1, :meter) # => <AUOM::Unit @scalar=2 meter^2>
    #
    #   # different units
    #   Unit.new(2, :meter) * Unit.new(1, :euro) # => <AUOM::Unit @scalar=2 meter*euro>
    #
    # @api public
    #
    def *(other)
      klass = self.class
      other = klass.convert(other)

      klass.new(
        other.scalar * scalar,
        numerators + other.numerators,
        denominators + other.denominators
      )
    end

    # Return division result
    #
    # @param [Object] other
    #
    # @return [Unit]
    #
    # @example
    #
    #   # unitless
    #   Unit.new(2) / Unit.new(1) # => <Unit @scalar=2>
    #
    #   # with unit
    #   Unit.new(2, :meter) / Unit.new(1, :meter) # => <AUOM::Unit @scalar=2>
    #
    #   # different units
    #   Unit.new(2, :meter) / Unit.new(1, :euro) # => <AUOM::Unit @scalar=2 meter/euro>
    #
    # @api public
    #
    def /(other)
      klass = self.class
      other = klass.convert(other)

      self * klass.new(
        1 / other.scalar,
        other.denominators,
        other.numerators
      )
    end

  end # Algebra
end # AUOM
