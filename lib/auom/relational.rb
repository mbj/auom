# frozen_string_literal: true

module AUOM
  # Mixin to add relational operators
  module Relational
    # Perform comparison operation
    #
    # @param [Unit] other
    #
    # @return [Object]
    #
    # @api private
    #
    def <=>(other)
      assert_same_unit(other)

      scalar <=> other.scalar
    end
  end # Relational
end # AUOM
