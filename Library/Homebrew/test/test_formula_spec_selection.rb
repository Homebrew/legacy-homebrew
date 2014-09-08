require 'testing_env'
require 'formula'

class FormulaSpecSelectionTests < Homebrew::TestCase
  def assert_spec_selected(spec)
    assert_equal @_f.send(spec), @_f.active_spec
  end

  def assert_spec_unset(spec)
    assert_nil @_f.send(spec)
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

  def test_incomplete_spec_not_selected
    formula do
      sha1 TEST_SHA1
      version '1.0'
      head 'foo'
    end

    assert_spec_selected :head
  end

  def test_incomplete_stable_not_set
    formula do
      sha1 TEST_SHA1
      devel { url 'foo-1.1a' }
      head 'foo'
    end

    assert_spec_unset :stable
    assert_spec_selected :devel
  end

  def test_selects_head_when_requested
    formula("test", Pathname.new(__FILE__).expand_path, :head) do
      url 'foo-1.0'
      devel { url 'foo-1.1a' }
      head 'foo'
    end

    assert_spec_selected :head
  end

  def test_selects_devel_when_requested
    formula("test", Pathname.new(__FILE__).expand_path, :devel) do
      url 'foo-1.0'
      devel { url 'foo-1.1a' }
      head 'foo'
    end

    assert_spec_selected :devel
  end

  def test_incomplete_devel_not_set
    formula do
      url 'foo-1.0'
      devel { version '1.1a' }
      head 'foo'
    end

    assert_spec_unset :devel
    assert_spec_selected :stable
  end

  def test_does_not_raise_for_missing_spec
    formula("test", Pathname.new(__FILE__).expand_path, :devel) do
      url 'foo-1.0'
      head 'foo'
    end

    assert_spec_selected :stable
  end
end
