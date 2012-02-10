module SUnits
  module Helper
    def self.extract_options(arguments)
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
    end

    def self.prettify_unit_part(base)
      base.group_by { |item| item }.map do |x,y| 
        length = y.length; 
        if length > 1
          "#{x}^#{length}"
        else
          x.to_s
        end
      end.join('')
    end

    def self.find_unit(value)
      unit = 
        case value
        when String
          # this is costly but avoids a String#to_sym witch has a security impact
          if Unit.units.keys.map(&:to_s).include?(value)
            find_unit(value.to_sym)
          end
        when Symbol
          Unit.units[value]
        else
          raise ArgumentError,"can only find units by symbol or string not by: #{value.class}"
        end
      if unit
        unit
      else
        raise ArgumentError,"unit for: #{value.inspect} could not be found"
      end
    end
  end
end
