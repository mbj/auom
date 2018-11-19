# frozen_string_literal: true

require 'minitest/autorun'
require 'mutant/minitest/coverage'

$LOAD_PATH << 'lib'
require 'auom'

class AUOMTest < Minitest::Test
  cover 'AUOM*'

private

  def unit(*arguments)
    AUOM::Unit.new(*arguments).tap do |unit|
      assert(unit.frozen?)
      assert(unit.numerators.frozen?)
      assert(unit.denominators.frozen?)
      assert(unit.unit.frozen?)
    end
  end

  class Binary < self

  private

    def object
      unit(*self.class::ARGUMENTS)
    end

    def apply(operand, expected)
      assert_equal(
        expected,
        object.public_send(
          self.class::METHOD,
          operand
        )
      )
    end

    def incompatible_apply(operand)
      exception = assert_raises(ArgumentError, message) do
        apply(operand, nil)
      end

      assert_equal('Incompatible units', exception.message)
    end

    class Add < self
      METHOD = :+

      cover 'AUOM::Algebra#+'

      class Unitless < self
        ARGUMENTS = [1].freeze

        def test_integer
          apply(1, unit(2))
        end

        def test_unitless
          apply(unit(1), unit(2))
        end

        def test_unitful
          incompatible_apply(unit(2, :meter))
        end
      end

      class Unitful < self
        ARGUMENTS = [1, :meter, :euro].freeze

        def test_integer
          incompatible_apply(2)
        end

        def test_incompatible_unit
          incompatible_apply(unit(2, :meter))
        end

        def test_compatible_unit
          apply(unit(2, :meter, :euro), unit(3, :meter, :euro))
        end
      end
    end

    class Subtract < self
      METHOD = :-

      cover 'AUOM::Algebra#-'

      class Unitless < self
        ARGUMENTS = [2].freeze

        def test_integer
          apply(1, unit(1))
        end

        def test_unitless
          apply(unit(1), unit(1))
        end

        def test_unitful
          incompatible_apply(unit(2, :meter))
        end
      end

      class Unitful < self
        ARGUMENTS = [2, :meter, :euro].freeze

        def test_integer
          incompatible_apply(2)
        end

        def test_incompatible_unit
          incompatible_apply(unit(2, :meter))
        end

        def test_compatible_unit
          apply(unit(1, :meter, :euro), unit(1, :meter, :euro))
        end
      end
    end

    class Divide < self
      cover 'AUOM::Algebra#/'

      METHOD = :/

      class Unitless < self
        ARGUMENTS = [4].freeze

        def test_integer
          apply(2, unit(2))
        end

        def test_unitless
          apply(unit(2), unit(2))
        end

        def test_unit
          apply(unit(2, :meter), unit(2, [], :meter))
        end
      end

      class Unitful < self
        ARGUMENTS = [2, :meter].freeze

        def test_integer
          apply(1, object)
        end

        def test_unitless
          apply(unit(1), object)
        end

        def test_unit_remove_to_unitless
          apply(unit(1, :meter), unit(2))
        end

        def test_unit_remove_denominator
          apply(unit(1, :meter, :euro), unit(2, :euro))
        end

        def test_unit_add_to_numerator
          apply(unit(1, [], :euro), unit(2, %i[meter euro]))
        end
      end
    end

    class Multiply < self
      cover 'AUOM::Algebra#*'

      METHOD = :*

      class Unitless < self
        ARGUMENTS = [5].freeze

        def test_integer
          apply(5, unit(25))
        end

        def test_unitless
          apply(unit(5), unit(25))
        end

        def test_unit_numerator_addition
          apply(unit(5, :euro), unit(25, :euro))
        end

        def test_unit_denominator_addition
          apply(unit(5, [], :euro), unit(25, [], :euro))
        end
      end

      class Unitful < self
        ARGUMENTS = [5, :meter].freeze

        def test_integer
          apply(5, unit(25, :meter))
        end

        def test_unitless
          apply(unit(5), unit(25, :meter))
        end

        def test_unit_numerator_addition
          apply(unit(5, :meter), unit(25, %i[meter meter]))
        end

        def test_unit_denominator_addition
          apply(unit(5, [], :euro), unit(25, :meter, :euro))
        end

        def test_unit_canelation
          apply(unit(5, [], :meter), unit(25))
        end
      end
    end

    class Comparable < self
      cover 'AUOM::Relational#<=>'

      METHOD = :<=>

      class Unitless < self
        ARGUMENTS = [6].freeze

        def test_equal
          apply(unit(6), 0)
        end

        def test_smaller
          apply(unit(5), 1)
        end

        def test_bigger
          apply(unit(7), -1)
        end

        def test_unitful
          incompatible_apply(unit(7, :euro))
        end
      end

      class Unitful < self
        ARGUMENTS = [7, :meter].freeze

        def test_equal
          apply(unit(7, :meter), 0)
        end

        def test_smaller
          apply(unit(6, :meter), 1)
        end

        def test_bigger
          apply(unit(8, :meter), -1)
        end

        def test_unitless
          incompatible_apply(unit(7))
        end

        def test_incompatible_unit
          incompatible_apply(unit(7, :euro))
        end
      end
    end

    class Equalization < self
      cover 'AUOM::Equalization#=='

      METHOD = :==

      class Unitless < self
        ARGUMENTS = [8].freeze

        def test_same_integer
          apply(8, true)
        end

        def test_different_integer
          apply(9, false)
        end

        def test_same_unit_same_scalar
          apply(unit(8), true)
        end

        def test_same_unit_different_scalar
          apply(unit(9), false)
        end

        def test_different_unit_same_scalar
          apply(unit(8, :meter), false)
        end
      end
    end

    class SameUnit < self
      cover 'AUOM::Unit#same_unit'
      METHOD           = :same_unit?
      ARGUMENTS        = [9, :meter].freeze

      def test_same_unit
        apply(unit(10, :meter), true)
      end

      def test_incompatible_unit
        apply(unit(10), false)
      end
    end

    class AssertSameUnit < self
      cover 'AUOM::Unit#assert_same_unit'

      METHOD = :assert_same_unit
      ARGUMENTS = [9, :meter].freeze

      def test_same_unit
        apply(unit(10, :meter), object)
      end

      def test_returns_self
        assert_equal(object, object.assert_same_unit(unit(10, :meter)))
      end

      def test_incompatible_unit
        incompatible_apply(unit(10))
      end
    end
  end

  class Unary < self

  private

    def apply(object, expected)
      assert_equal(
        expected,
        object.public_send(self.class::METHOD)
      )
    end

    class Inspect < self
      cover 'AUOM::Inspection#inspect'

      METHOD = :inspect

      def test_unitless
        apply(unit(1), '<AUOM::Unit @scalar=1>')
      end

      def test_unitless_fraction
        apply(unit(Rational(1, 2)), '<AUOM::Unit @scalar=~0.5000>')
      end

      def test_unit_only_numerator
        apply(unit(Rational(1, 3), :meter), '<AUOM::Unit @scalar=~0.3333 meter>')
      end

      def test_unit_only_denominator
        apply(
          unit(Rational(1, 3), [], :meter),
          '<AUOM::Unit @scalar=~0.3333 1/meter>'
        )
      end

      def test_unit_nominator_denominator
        apply(
          unit(Rational(1, 3), :euro, :meter),
          '<AUOM::Unit @scalar=~0.3333 euro/meter>'
        )
      end

      def test_complex_units
        apply(
          unit(1, %i[euro euro], :meter),
          '<AUOM::Unit @scalar=1 euro^2/meter>'
        )

        apply(
          unit(1, %i[meter meter euro euro kilogramm], :meter),
          '<AUOM::Unit @scalar=1 euro^2*kilogramm*meter>'
        )
      end
    end

    class Denomnators < self
      cover 'AUOM::Unit#denominators'

      METHOD = :denominators

      def test_unitless
        apply(unit(1), [])
      end

      def test_unit_with_numerators
        apply(unit(1, :meter), [])
      end

      def test_unit_with_denominators
        apply(unit(1, [], :euro), %i[euro])
      end
    end

    class Numerators < self
      cover 'AUOM::Unit#numerators'

      METHOD = :numerators

      def test_unitless
        apply(unit(1), [])
      end

      def test_unit_with_numerators
        apply(unit(1, :meter), %i[meter])
      end

      def test_unit_with_denominators
        apply(unit(1, [], :euro), [])
      end
    end

    class UnitlessPredicate < self
      cover 'AUOM::Unit#unitless?'

      METHOD = :unitless?

      def test_unitless
        apply(unit(1), true)
      end

      def test_numerator_unit
        apply(unit(1, :meter), false)
      end

      def test_denominator_unit
        apply(unit(1, [], :meter), false)
      end

      def test_numerator_denoninator_unit
        apply(unit(1, :euro, :meter), false)
      end
    end

    class Unit < self
      cover 'AUOM::Unit#unitless?'

      METHOD = :unit

      def test_unitless
        apply(unit(1), [[], []])
      end

      def test_unit_with_numerators
        apply(unit(1, :meter), [%i[meter], []])
      end

      def test_unit_with_denominators
        apply(unit(1, [], :euro), [[], %i[euro]])
      end

      def test_unit_with_numerators_and_denominators
        apply(unit(1, :meter, :euro), [%i[meter], %i[euro]])
      end
    end
  end

  class ClassMethods < self
    TARGET = AUOM::Unit

  private

    def apply(input, expected)
      public_send(
        expected.nil? ? :assert_nil : :assert_equal,
        expected,
        self.class::TARGET.public_send(self.class::METHOD, input)
      )
    end

    class TryConvert < self
      cover 'AUOM::Unit.try_convert'

      METHOD = :try_convert

      def test_nil
        apply(nil, nil)
      end

      def test_integer
        apply(1, unit(1))
      end

      def test_rational
        apply(Rational(2, 1), unit(Rational(2, 1)))
      end

      def test_object
        apply(Object.new, nil)
      end
    end

    class PrettifyUnitPart < self
      cover 'AUOM::Inspection.prettify_unit_part'

      TARGET = AUOM::Inspection
      METHOD = :prettify_unit_part

      def test_simple
        apply(%i[meter], 'meter')
      end

      def test_complex
        apply(%i[meter meter euro euro kilogramm], 'euro^2*meter^2*kilogramm')
      end
    end

    class Convert < self
      cover 'AUOM::Unit.convert'

      METHOD = :convert

      def incompatible_apply(input)
        exception = assert_raises(ArgumentError) do
          apply(input, nil)
        end

        assert_equal(
          "Cannot convert #{input.inspect} to AUOM::Unit",
          exception.message
        )
      end

      def test_integer
        apply(1, unit(1))
      end

      def test_rational
        apply(Rational(2, 1), unit(Rational(2, 1)))
      end

      def test_nil
        incompatible_apply(nil)
      end

      def test_object
        incompatible_apply(Object.new)
      end
    end

    class New < self
      cover 'AUOM::Unit.new'

      METHOD = :new

      def test_incompatible_scalar
        exception = assert_raises(ArgumentError, message) do
          unit(nil)
        end

        assert_equal('nil cannot be converted to rational', exception.message)
      end

      def test_unknown_unit
        exception = assert_raises(ArgumentError, message) do
          unit(1, :foo)
        end

        assert_equal('Unknown unit :foo', exception.message)
      end

      def test_integer
        assert_equal(1, unit(1).scalar)
      end

      def test_rational
        assert_equal(Rational(1), unit(Rational(1)).scalar)
      end

      def test_normalized_numerator_unit
        assert_equal(unit(1, :kilometer), unit(1000, :meter))
      end

      def test_normalized_numerator_scalar
        assert_equal(Rational(1000), unit(1, :kilometer).scalar)
      end

      def test_normalized_denominator_unit
        assert_equal(unit(1, [], :kilometer), unit(Rational(1, 1000), [], :meter))
      end

      def test_normalized_denominator_scalar
        assert_equal(Rational(1, 1000), unit(1, [], :kilometer).scalar)
      end

      def test_sorted_numerator
        assert_equal(%i[euro meter], unit(1, %i[meter euro]).numerators)
      end

      def test_sorted_denominator
        assert_equal(%i[euro meter], unit(1, [], %i[meter euro]).denominators)
      end

      def test_reduced_unit
        assert_equal([[], []], unit(1, :meter, :meter).unit)
      end
    end
  end
end
