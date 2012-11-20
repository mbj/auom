module AUOM
  # Mixin to add relational operators
  module Relational

    # Test if unit is less than or equal to other
    #
    # @param [Unit] other
    #
    # @return [true]
    #   if unit is less than other
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    #
    def less_than_or_equal_to?(other)
      relational_operation(other, :<=)
    end
    alias_method :<=, :less_than_or_equal_to?

    # Test if unit is greater than or equal toother
    #
    # @param [Unit] other
    #
    # @return [true]
    #   if unit is greater than other
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    #
    def greater_than_or_equal_to?(other)
      relational_operation(other, :>=)
    end
    alias_method :>=, :greater_than_or_equal_to?

    # Test if unit is less than other
    #
    # @param [Unit] other
    #
    # @return [true]
    #   if unit is less than other
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    #
    def less_than?(other)
      relational_operation(other, :<)
    end
    alias_method :<, :less_than?

    # Test if unit is greater than other
    #
    # @param [Unit] other
    #
    # @return [true]
    #   if unit is greater than other
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    #
    def greater_than?(other)
      relational_operation(other, :>)
    end
    alias_method :<, :less_than?

  private

    # Peform relational operation
    #
    # @param [Unit] other
    # @param [Symbol] operation
    #
    # @return [Object]
    #
    # @api private
    #
    def relational_operation(other, operation)
      assert_same_unit(other)
      scalar.public_send(operation, other.scalar)
    end

  end
end
