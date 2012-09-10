module AUOM
  # Equalization for auom units
  module Equalization
    # Check for equivalent value and try to convert
    #
    # @param [Object] other
    #
    # @return [true]
    #   return true if is other is a unit and scalar and unit is the same after try of conversion.
    #
    # @return [false]
    #   return false otherwise
    #
    # @example
    #
    #   u = Unit.new(1, :meter)
    #   u == u                   # => true
    #   u == 1                   # => false
    #   u == Unit.new(1, :meter) # => true
    #
    #   u = Unit.new(1)
    #   u == 1                   # => true
    #   u == Rational(1)         # => true
    #   u == 1.0                 # => false
    #
    # @api public
    #
    def ==(other)
      eql?(self.class.try_convert(other))
    end

    # Check for equivalent value and not try to convert
    #
    # @param [Object] other
    #
    # @example
    #
    #   u = Unit.new(1, :meter)
    #   u == u                   # => true
    #   u == 1                   # => false
    #   u == Unit.new(1, :meter) # => true
    #
    #   u = Unit.new(1)
    #   u == 1                   # => false
    #   u == Rational(1)         # => false
    #   u == 1.0                 # => false
    #
    # @return [true]
    #   return true if is other is a unit and scalar and unit is the same
    #
    # @return [false]
    #   return false otherwise
    #
    # @api public
    #
    def eql?(other)
      (instance_of?(other.class) && cmp?(other))
    end

    # Return hash value
    #
    # @return [Fixnum]
    #
    # @example
    #
    #   Unit.new(1, :meter).to_hash # => 012345678
    #
    # @api public
    #
    def hash
      scalar.hash ^ unit.hash
    end

  private

    # Compare with other unit instance 
    #
    # @return [true]
    #   returns true if unit and scalar is aequivalent
    # 
    # @return [false]
    #   return false otherwise
    #
    # @api private
    #
    def cmp?(other)
      scalar.eql?(other.scalar) && unit.eql?(other.unit)
    end
  end
end
