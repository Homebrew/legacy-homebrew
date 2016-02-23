require "testing_env"
require "exceptions"

class ExceptionsTest < Homebrew::TestCase
  def test_multiple_versions_installed_error
    assert_equal "foo has multiple installed versions",
      MultipleVersionsInstalledError.new("foo").to_s
  end

  def test_no_such_keg_error
    assert_equal "No such keg: #{HOMEBREW_CELLAR}/foo",
      NoSuchKegError.new("foo").to_s
  end

  def test_formula_validation_error
    assert_equal %(invalid attribute for formula 'foo': sha257 ("magic")),
      FormulaValidationError.new("foo", "sha257", "magic").to_s
  end

  def test_formula_unavailable_error
    e = FormulaUnavailableError.new "foo"
    assert_nil e.dependent_s

    e.dependent = "foo"
    assert_nil e.dependent_s

    e.dependent = "foobar"
    assert_equal "(dependency of foobar)", e.dependent_s

    assert_equal "No available formula with the name \"foo\" (dependency of foobar)",
      e.to_s
  end

  def test_tap_formula_unavailable_error
    t = stub({:user => "u", :repo => "r", :to_s => "u/r", :installed? => false})
    assert_match "Please tap it and then try again: brew tap u/r",
      TapFormulaUnavailableError.new(t, "foo").to_s
  end

  def test_tap_unavailable_error
    assert_equal "No available tap foo.\n", TapUnavailableError.new("foo").to_s
  end

  def test_tap_already_tapped_error
    assert_equal "Tap foo already tapped.\n",
      TapAlreadyTappedError.new("foo").to_s
  end

  def test_pin_status_error
    assert_equal "foo is already pinned.",
      TapPinStatusError.new("foo", true).to_s
    assert_equal "foo is already unpinned.",
      TapPinStatusError.new("foo", false).to_s
  end

  def test_build_error
    f = stub({:name => "foo"})
    assert_equal "Failed executing: badprg arg1 arg2",
      BuildError.new(f, "badprg", %w[arg1 arg2], {}).to_s
  end

  def test_operation_in_progress_error
    assert_match "Operation already in progress for bar",
      OperationInProgressError.new("bar").to_s
  end

  def test_formula_installation_already_attempted_error
    f = stub({:full_name => "foo/bar"})
    assert_equal "Formula installation already attempted: foo/bar",
      FormulaInstallationAlreadyAttemptedError.new(f).to_s
  end

  def test_formula_conflict_error
    f = stub({:full_name => "foo/qux"})
    c = stub({:name => "bar", :reason => "I decided to"})
    assert_match "Please `brew unlink bar` before continuing.",
      FormulaConflictError.new(f, [c]).to_s
  end

  def test_compiler_selection_error
    f = stub({:full_name => "foo"})
    assert_match "foo cannot be built with any available compilers.",
      CompilerSelectionError.new(f).to_s
  end

  def test_curl_download_strategy_error
    assert_equal "File does not exist: /tmp/foo",
      CurlDownloadStrategyError.new("file:///tmp/foo").to_s
    assert_equal "Download failed: http://brew.sh",
      CurlDownloadStrategyError.new("http://brew.sh").to_s
  end

  def test_error_during_execution
    assert_equal "Failure while executing: badprg arg1 arg2",
      ErrorDuringExecution.new("badprg", %w[arg1 arg2]).to_s
  end

  def test_checksum_mismatch_error
    h1 = stub({:hash_type => "sha256", :to_s => "deadbeef"})
    h2 = stub({:hash_type => "sha256", :to_s => "deadcafe"})
    assert_match "SHA256 mismatch",
      ChecksumMismatchError.new("/file.tar.gz", h1, h2).to_s
  end

  def test_resource_missing_error
    f = stub({:full_name => "bar"})
    r = stub({:inspect => "<resource foo>"})
    assert_match "bar does not define resource <resource foo>",
      ResourceMissingError.new(f, r).to_s
  end

  def test_duplicate_resource_error
    r = stub({:inspect => "<resource foo>"})
    assert_equal "Resource <resource foo> is defined more than once",
      DuplicateResourceError.new(r).to_s
  end

  def test_bottle_version_mismatch_error
    f = stub({:full_name => "foo"})
    assert_match "Bottle version mismatch",
      BottleVersionMismatchError.new("/foo.bottle.tar.gz", "1.0", f, "1.1").to_s
  end
end
