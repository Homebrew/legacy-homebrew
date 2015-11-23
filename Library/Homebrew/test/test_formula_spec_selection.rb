require "testing_env"
require "formula"

class FormulaSpecSelectionTests < Homebrew::TestCase
  def test_selects_stable_by_default
    f = formula {
      url "foo-1.0"
      devel { url "foo-1.1a" }
      head "foo"
    }

    assert_predicate f, :stable?
  end

  def test_selects_stable_when_exclusive
    f = formula { url "foo-1.0" }
    assert_predicate f, :stable?
  end

  def test_selects_devel_before_head
    f = formula {
      devel { url "foo-1.1a" }
      head "foo"
    }

    assert_predicate f, :devel?
  end

  def test_selects_devel_when_exclusive
    f = formula { devel { url "foo-1.1a" } }
    assert_predicate f, :devel?
  end

  def test_selects_head_when_exclusive
    f = formula { head "foo" }
    assert_predicate f, :head?
  end

  def test_incomplete_spec_not_selected
    f = formula {
      sha1 TEST_SHA1
      version "1.0"
      head "foo"
    }

    assert_predicate f, :head?
  end

  def test_incomplete_stable_not_set
    f = formula {
      sha1 TEST_SHA1
      devel { url "foo-1.1a" }
      head "foo"
    }

    assert_nil f.stable
    assert_predicate f, :devel?
  end

  def test_selects_head_when_requested
    f = formula("test", Pathname.new(__FILE__).expand_path, :head) {
      url "foo-1.0"
      devel { url "foo-1.1a" }
      head "foo"
    }

    assert_predicate f, :head?
  end

  def test_selects_devel_when_requested
    f = formula("test", Pathname.new(__FILE__).expand_path, :devel) {
      url "foo-1.0"
      devel { url "foo-1.1a" }
      head "foo"
    }

    assert_predicate f, :devel?
  end

  def test_incomplete_devel_not_set
    f = formula {
      url "foo-1.0"
      devel { version "1.1a" }
      head "foo"
    }

    assert_nil f.devel
    assert_predicate f, :stable?
  end

  def test_does_not_raise_for_missing_spec
    f = formula("test", Pathname.new(__FILE__).expand_path, :devel) {
      url "foo-1.0"
      head "foo"
    }

    assert_predicate f, :stable?
  end
end
