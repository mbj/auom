# frozen_string_literal: true

module AUOM
  # The AUOM algebra
  module Algebra
    # Return addition result
    #
    # @param [Object] operand
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
    def add(operand)
      klass = self.class
      operand = klass.convert(operand)
      assert_same_unit(operand)
      klass.new(operand.scalar + scalar, numerators, denominators)
    end

    alias_method :+, :add

    # Return subtraction result
    #
    # @param [Object] operand
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
    def subtract(operand)
      add(operand * -1)
    end

    alias_method :-, :subtract

    # Return multiplication result
    #
    # @param [Object] operand
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
    def multiply(operand)
      klass = self.class
      operand = klass.convert(operand)

      klass.new(
        operand.scalar * scalar,
        numerators + operand.numerators,
        denominators + operand.denominators
      )
    end

    alias_method :*, :multiply

    # Return division result
    #
    # @param [Object] operand
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
    def divide(operand)
      klass = self.class
      operand = klass.convert(operand)

      self * klass.new(
        1 / operand.scalar,
        operand.denominators,
        operand.numerators
      )
    end

    alias_method :/, :divide

  end # Algebra
end # AUOM
