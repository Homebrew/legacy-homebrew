require "testing_env"
require "formula_pin"

class FormulaPinTests < Homebrew::TestCase
  class FormulaDouble
    def name
      "double"
    end

    def rack
      Pathname.new("#{HOMEBREW_CELLAR}/#{name}")
    end

    def installed_prefixes
      rack.directory? ? rack.subdirs : []
    end

    def installed_kegs
      installed_prefixes.map { |d| Keg.new d }
    end
  end

  def setup
    @f   = FormulaDouble.new
    @pin = FormulaPin.new(@f)
    @f.rack.mkpath
  end

  def test_not_pinnable
    refute_predicate @pin, :pinnable?
  end

  def test_pinnable_if_kegs_exist
    (@f.rack+"0.1").mkpath
    assert_predicate @pin, :pinnable?
  end

  def test_unpin
    (@f.rack+"0.1").mkpath
    @pin.pin

    assert_predicate @pin, :pinned?
    assert_equal 1, FormulaPin::PINDIR.children.length

    @pin.unpin

    refute_predicate @pin, :pinned?
    refute_predicate FormulaPin::PINDIR, :directory?
  end

  def teardown
    @f.rack.rmtree
  end
end
