# frozen_string_literal: true

module AUOM
  # Inspection module for auom units
  module Inspection
    INSPECT_FORMAT = '<%s @scalar=%s%s>'
    SCALAR_FORMAT  = '~%0.4f'
    UNIT_FORMAT    = ' %s/%s'

    # Return inspectable representation
    #
    # @return [String]
    #
    # @api private
    #
    def inspect
      format(INSPECT_FORMAT, self.class, pretty_scalar, pretty_unit)
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
      counts(base).map do |unit, length|
        length > 1 ? "#{unit}^#{length}" : unit
      end.join('*')
    end

  private

    # Return prettified scalar
    #
    # @return [String]
    #
    # @api private
    #
    def pretty_scalar
      if reminder?
        format(SCALAR_FORMAT, scalar)
      else
        scalar.to_int
      end
    end

    # Return prettified unit part
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

      numerator   = Inspection.prettify_unit_part(numerators)
      denominator = Inspection.prettify_unit_part(denominators)

      numerator   = '1' if numerator.empty?
      return " #{numerator}" if denominator.empty?

      format(UNIT_FORMAT, numerator, denominator)
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

    # Return unit counts
    #
    # @param [Array] base
    #
    # @return [Hash]
    #
    # @api private
    #
    # rubocop:disable Metrics/MethodLength
    def self.counts(base)
      counts = base.each_with_object(Hash.new(0)) do |unit, hash|
        hash[unit] += 1
      end

      counts.sort do |left, right|
        result = right.last <=> left.last
        if result.equal?(0)
          left.first <=> right.first
        else
          result
        end
      end
    end
    private_class_method :counts
    # rubocop:enable Metrics/MethodLength

  end # Inspection
end # AUOM
