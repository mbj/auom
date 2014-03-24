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

  end # Equalization
end # AUOM
