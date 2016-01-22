require "testing_env"
require "formula"
require "caveats"

class CaveatsTests < Homebrew::TestCase
  def setup
    @f = formula { url "foo-1.0" }
    @c = Caveats.new @f
  end

  def test_f
    assert_equal @f, @c.f
  end

  def test_empty?
    assert @c.empty?

    f = formula do
      url "foo-1.0"

      def caveats
        "something"
      end
    end
    c = Caveats.new f

    refute c.empty?
  end
end
