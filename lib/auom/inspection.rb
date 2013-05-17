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
      sprintf('<%s @scalar=%s%s>', self.class.name, pretty_scalar, pretty_unit)
    end

  private

    # Return prettyfied scalar
    #
    # @return [String]
    #
    # @api private
    #
    def pretty_scalar
      unless fractions?
        integer_value
      else
        '~%0.4f' % float_value
      end
    end

    # Return float value
    #
    # @return [Float]
    #
    # @api private
    #
    def float_value
      scalar.to_f
    end

    # Return integer value
    #
    # @return [Fixnum]
    #
    # @api private
    #
    def integer_value
      scalar.to_i
    end

    # Return prettyfied unit part
    #
    # @return [String]
    #
    # @api private
    #
    def pretty_unit
      return '' if unitless?

      numerator   = Inspection.prettify_unit_part(@numerators)
      denominator = Inspection.prettify_unit_part(@denominators)

      numerator   = '1' if numerator.empty?
      if denominator.empty?
        return " #{numerator}"
      end


      sprintf(' %s/%s', numerator, denominator)
    end

    # Check if scalar has fractions in decimal representation
    #
    # @return [true]
    #   if scalar has fractions in decimal representation
    #
    # @return [false]
    #   if scalar NOT has fractions in decimal representation
    #
    # @api private
    #
    def fractions?
      !(scalar_numerator % scalar_denominator).zero?
    end

    # Return scalar numerator
    #
    # @return [Fixnum]
    #
    # @api private
    #
    def scalar_numerator
      scalar.numerator
    end

    # Return scalar denominator
    #
    # @return [Fixnum]
    #
    # @api private
    #
    def scalar_denominator
      scalar.denominator
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
      counts(base).map { |unit,length| length > 1 ? "#{unit}^#{length}" : unit }.join('*')
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
      counts = base.each_with_object(Hash.new(0)) { |unit,hash| hash[unit] += 1 }
      counts.sort do |left,right|
        result = right.last <=> left.last
        if result == 0
          left.first <=> right.first
        else
          result
        end
      end
    end

    private_class_method :counts
  end
end
