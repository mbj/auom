module AUOM
  # Inspection module for auom units
  module Inspection
    # Return inspectable representation
    #
    # @return [String]
    #
    # @api private
    #
    def inspect
      sprintf('<%s @scalar=%s%s>', self.class, pretty_scalar, pretty_unit)
    end

  private

    # Return prettyfied scalar
    #
    # @return [String]
    #
    # @api private
    #
    def pretty_scalar
      if reminder?
        sprintf('~%0.4f', scalar)
      else
        scalar.to_i
      end
    end

    # Return prettyfied unit part
    #
    # @return [String]
    #   if there is a prettifiable unit part
    #
    # @return [nil]
    #   otherwise
    #
    # @api private
    #
    def pretty_unit
      return if unitless?

      numerator   = Inspection.prettify_unit_part(@numerators)
      denominator = Inspection.prettify_unit_part(@denominators)

      numerator   = '1' if numerator.empty?
      if denominator.empty?
        return " #{numerator}"
      end

      sprintf(' %s/%s', numerator, denominator)
    end

    # Test if scalar has and reminder in decimal representation
    #
    # @return [true]
    #   if there is a reminder
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    #
    def reminder?
      !(scalar % scalar.denominator).zero?
    end

    # Return prettified units
    #
    # @param [Array] base
    #
    # @return [String]
    #
    # @api private
    #
    def self.prettify_unit_part(base)
      counts(base).map { |unit, length| length > 1 ? "#{unit}^#{length}" : unit }.join('*')
    end

    # Return unit counts
    #
    # @param [Array] base
    #
    # @return [Hash]
    #
    # @api private
    #
    def self.counts(base)
      counts = base.each_with_object(Hash.new(0)) { |unit, hash| hash[unit] += 1 }
      counts.sort do |left, right|
        result = right.last <=> left.last
        if result == 0
          left.first <=> right.first
        else
          result
        end
      end
    end

    private_class_method :counts

  end # Inspection
end # AUOM
