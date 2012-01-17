require 'rational'

# Small and imcomplete units implementation. But serves well 
# for my use case where ruby-units behaviour of requireing mathn is 
# unacceptable.

module SUnits
  class Unit
    # TODO: This class was written before Virtus::ValueObject. 
    # We'll be able to move much of the typecasting logic to Virtus::Coercion.
    # This should save a lot LOC. 
    #
    # Assume backports is present for 1.8.

    attr_reader :scalar,:numerators,:denominators

    # TODO: Make configurable
    def self.units
      @units ||= {
        :none =>      [1],
        :item =>      [1,:item],
        :liter =>     [1,:liter],
        :pack =>      [1,:pack],
        :can =>       [1,:can],
        :kilogramm => [1,:kilogramm],
        :euro =>      [1,:euro],
        :meter =>     [1,:meter],
        :kilometer => [1000,:meter]
      }
    end

    def self.find_unit(value)
      unit = case value
             when String
               if units.keys.map(&:to_s).include? value
                 find_unit(value.to_sym)
               end
             when Symbol
               units[value]
             else
               raise ArgumentError,"can only find units by symbol or string not by: #{value.class}"
             end
      if unit
        unit
      else
        raise ArgumentError,"unit for: #{value.inspect} could not be found"
      end
    end

    def initialize(*arguments)
      value,numerators,denominators = 
        if arguments.length == 1 and arguments.first.kind_of?(Hash)
          hash = arguments.first.dup
          scalar = hash.delete('scalar') || hash.delete(:scalar)
          unless scalar
            raise ArgumentError,'hash is missung :scalar or "scalar"'
          end
          numerators = hash.delete('numerators') || hash.delete(:numerators)
          denominators = hash.delete('denominators') || hash.delete(:denominators)
          # Remove database searchable version
          hash.delete('value')
          hash.delete(:value)
          unless hash.empty?
            raise ArgumentError,"Illegal keys in hash: #{hash.keys}"
          end
          [scalar,numerators,denominators]
        elsif arguments.length <= 3
          arguments
        else
          raise ArgumentError,'I do not take more than 3 arguments!'
        end

      # compact is needed for ruby-1.8.7 and rbx
      numerators =   [*numerators].compact
      denominators = [*denominators].compact

      @scalar = 
        case value
        when Fixnum
          Rational(value,1)
        when Array
          if value.length != 2
            raise ArgumentError,'scalar array must be of length two'
          end
          numerator,denominator = value
          unless numerator.kind_of?(Fixnum)
            raise ArgumentError,'numerator of scalar muste be of kind Fixnum'
          end
          unless denominator.kind_of?(Fixnum)
            raise ArgumentError,"denominator of scalar muste be of kind Fixnum was :#{denominator.class}"
          end
          Rational(numerator,denominator)
        when String
          match = /\A(\d+)(?:\.(\d+))?\Z/.match value
          unless match
            raise ArgumentError,'+scalar+ is not in a compatible string format'
          end
          full,fraction = match[1],match[2]
          denominator = 10 ** (fraction ? fraction.length : 0)
          Rational((full.to_i*denominator)+fraction.to_i,denominator)
        when Rational
          value
        else
          raise ArgumentError,"+scalar+ must be kind of Rational, Fixnum or in a compatible String format, was: #{value.inspect}"
        end

      numerators.map! do |numerator|
        scalar,numerator = self.class.find_unit(numerator)
        @scalar *= scalar
        numerator
      end

      denominators.map! do |denominator|
        scalar,denominator = self.class.find_unit(denominator)
        @scalar /= scalar
        denominator
      end

      numerators   = numerators.  delete_if { |numerator  | denominators.delete_at(denominators.index(numerator)   || denominators.length) }
      denominators = denominators.delete_if { |denominator| numerators.  delete_at(numerators.  index(denominator) || numerators.  length) }

      # Symbol#<=> is only present on mri 1.9
      @numerators   = numerators.  sort_by { |n| n.to_s }.freeze
      @denominators = denominators.sort_by { |n| n.to_s }.freeze

      freeze
    end

    def to_hash
      hash = {}
      hash[:scalar] = [scalar.numerator,scalar.denominator]
      mod = scalar.numerator % scalar.denominator
      hash[:value]  = mod.zero? ? scalar.to_i : scalar.to_f
      hash[:numerators] = @numerators unless @numerators.empty?
      hash[:denominators] = @denominators unless @denominators.empty?
      hash
    end

    def unit
      [@numerators,@denominators]
    end

    def inspect
      "<#{self.class.name} @scalar=#{"%0.5f" % @scalar.to_f} #{self.class.make_pretty(@numerators)}/#{self.class.make_pretty(@denominators)}>"
    end

    def +(operand)
      operand = self.class.convert operand

      unless operand.unit == self.unit
        raise ArgumentError,'cannot add incompatible units'
      end

      self.class.new(
        operand.scalar + @scalar,
        numerators.dup,
        denominators.dup
      )
    end

    def -(operand)
      self.+(self.class.convert(operand) * -1)
    end

    def *(operand)
      operand = self.class.convert operand
      self.class.new(
        operand.scalar * @scalar,
        numerators + operand.numerators,
        denominators + operand.denominators
      )
    end

    def /(operand)
      operand = self.class.convert operand
      self * self.class.new(
        1 / operand.scalar,
        operand.denominators.dup,
        operand.numerators.dup
      )
    end

    def ==(operand)
      operand = self.class.convert operand
      operand.scalar == @scalar && operand.unit == self.unit
    end

    def unitless?
      numerators.empty? and denominators.empty?
    end

  private

    def self.make_pretty(base)
      base.group_by { |item| item }.map do |x,y| 
        length = y.length; 
        if length > 1
          "#{x}^#{length}"
        else
          x.to_s
        end
      end.join('')
    end

    def self.convert(operand)
      case operand
      when self
        operand
      when Fixnum
        self.new(operand)
      when Rational
        self.new(operand)
      else
        raise ArgumentError,"+operand+ must be kind of Unit, Rational or Fixnum was #{operand.class}"
      end
    end
     
     def check_unit(operand)
       unless operand.kind_of?(self.class)
         raise "+operand+ is of incompatible type: #{operand.class}"
       end
     end
  end
end
