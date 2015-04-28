require 'testing_env'

# These are integration tests to make sure the vendored i18n gem is doing
# everything it's expected to do, especially in 1.8.x Rubies that aren't
# officially supported by it anymore.
#
class I18nWrapperTests < Homebrew::TestCase
  def test_standard_lookup
    assert_equal "This is a placeholder for Homebrew tests.", t("test.basic")
  end

  def test_basic_interpolation
    assert_equal "Homebrew tests are in Library/Homebrew/test",
                 t("test.interpolation", :path => "Library/Homebrew/test")
  end

  def test_interpolation_and_pluralization
    assert_equal "There are 99 bottles of beer on the wall.",
                 t("test.pluralisation", :count => 99)
    assert_equal "There are 2 bottles of beer on the wall.",
                 t("test.pluralisation", :count => 2)
    assert_equal "There is 1 bottle of beer on the wall.",
                 t("test.pluralisation", :count => 1)
  end
end
