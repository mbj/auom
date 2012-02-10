# Extensions for virtus to support rationals as first class citizens
module Virtus
  class Coercion
    class String < ::Virtus::Coercion::Object
      # Creates a rational from an String
      #
      # @example
      #   Virtus::Coercion::String.to_rational('1.9') => Rational(19,10)
      #
      # @param [String] value
      #
      # @return [Rational|String]
      #   returns Rational if is a valid rational
      #   retunrs String if not
      #
      # @api private
      def self.to_rational(value)
        to_numeric(value, :to_r)
      end
    end

    class Integer < ::Virtus::Coercion::Numeric
      # Creates a rational from an Integer
      #
      # @example
      #   Virtus::Coercion::Integer.to_rational(10) => Rational(10,1)
      #
      # @param [Integer] value
      #
      # @return [Rational]
      #
      # @api private
      def self.to_rational(value)
        Rational(value,1)
      end
    end

    class Array < ::Virtus::Coercion::Object
      # Creates a rational from an Array
      #
      # @example
      #   Virtus::Coercion::Array.to_rational([1,2]) => Rational(1,2)
      #
      # @example
      #   # not a compatible represetation
      #   Virtus::Coercion::Array.to_rational([1]) => [1]
      #
      # @param [Array] value
      #
      # @return [Rational|Array]
      #   returns Rational if successful
      #   returns Array if not
      #
      # @api private
      def self.to_rational(value)
        return value unless value.length == 2
        numerator,denominator = value
        return value unless numerator.kind_of?(::Fixnum)
        return value unless denominator.kind_of?(::Fixnum)
        Rational(numerator,denominator)
      end
    end
  end

  class Attribute
    # Rational 
    #
    # @example
    #   class Entity
    #     include Virtus
    #
    #     attribute :rational,Rational
    #   end
    #
    #   post = Entity.new(:rational => 1)
    #
    class Rational < Virtus::Attribute::Object
      primitive ::Rational
      coercion_method :to_rational
    end
  end
end

