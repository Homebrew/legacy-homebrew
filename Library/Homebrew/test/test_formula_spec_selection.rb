require 'testing_env'
require 'formula'

class FormulaSpecSelectionTests < Test::Unit::TestCase
  def formula(*args, &block)
    @_f = Class.new(Formula, &block).new(*args)
  end

  def assert_spec_selected(spec)
    assert_equal @_f.send(spec), @_f.active_spec
  end

  def test_selects_head_when_requested
    ARGV.stubs(:build_head?).returns(true)

    formula do
      url 'foo-1.0'
      devel { url 'foo-1.1a' }
      head 'foo'
    end

    assert_spec_selected :head
  end

  def test_selects_devel_when_requested
    ARGV.stubs(:build_devel?).returns(true)

    formula do
      url 'foo-1.0'
      devel { url 'foo-1.1a' }
      head 'foo'
    end

    assert_spec_selected :devel
  end

  def test_selects_bottle_when_available
    formula do
      def install_bottle?(*); true; end

      url 'foo-1.0'
      bottle do
        {
          :snow_leopard_32 => 'deadbeef'*5,
          :snow_leopard    => 'faceb00c'*5,
          :lion            => 'baadf00d'*5,
          :mountain_lion   => '8badf00d'*5,
        }.each_pair do |cat, val|
          sha1(val => cat)
        end
      end
    end

    assert_spec_selected :bottle
  end

  def test_selects_stable_by_default
    formula do
      url 'foo-1.0'
      devel { url 'foo-1.1a' }
      head 'foo'
    end

    assert_spec_selected :stable
  end

  def test_selects_stable_when_exclusive
    formula do
      url 'foo-1.0'
    end

    assert_spec_selected :stable
  end

  def test_selects_devel_before_head
    formula do
      devel { url 'foo-1.1a' }
      head 'foo'
    end

    assert_spec_selected :devel
  end

  def test_selects_devel_when_exclusive
    formula do
      devel { url 'foo-1.1a' }
    end

    assert_spec_selected :devel
  end

  def test_selects_head_when_exclusive
    formula do
      head 'foo'
    end

    assert_spec_selected :head
  end
end
