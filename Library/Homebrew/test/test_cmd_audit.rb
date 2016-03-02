require "testing_env"
require "fileutils"
require "pathname"
require "formulary"
require "cmd/audit"

class FormulaTextTests < Homebrew::TestCase
  def setup
    @dir = mktmpdir
  end

  def teardown
    FileUtils.rm_rf @dir
  end

  def formula_text(name, text)
    path = Pathname.new "#{@dir}/#{name}.rb"
    path.open("w") { |f| f.write text }
    FormulaText.new path
  end

  def test_simple_valid_formula
    ft = formula_text "valid", <<-EOS.undent
      class Valid < Formula
        url "http://www.example.com/valid-1.0.tar.gz"
      end
    EOS

    refute ft.has_DATA?, "The formula doesn't have DATA"
    refute ft.has_END?, "The formula doesn't have __END__"
    assert ft.has_trailing_newline?, "The formula have a trailing newline"

    assert ft =~ /\burl\b/, "The formula match 'url'"
    assert_nil ft.line_number(/desc/), "The formula doesn't match 'desc'"
    assert_equal 2, ft.line_number(/\burl\b/)
  end

  def test_trailing_newline
    ft = formula_text "newline", "class Newline < Formula; end"
    refute ft.has_trailing_newline?, "The formula doesn't have a trailing newline"
  end

  def test_has_data
    ft = formula_text "data", <<-EOS.undent
      class Data < Formula
        patch :DATA
      end
    EOS

    assert ft.has_DATA?, "The formula has DATA"
  end

  def test_has_end
    ft = formula_text "end", <<-EOS.undent
      class End < Formula
      end
      __END__
      a patch here
    EOS

    assert ft.has_END?, "The formula has __END__"
    assert_equal "class End < Formula\nend", ft.without_patch
  end
end

class FormulaAuditorTests < Homebrew::TestCase
  def setup
    @dir = mktmpdir
  end

  def teardown
    FileUtils.rm_rf @dir
  end

  def formula_auditor(name, text, options = {})
    path = Pathname.new "#{@dir}/#{name}.rb"
    path.open("w") { |f| f.write text }
    FormulaAuditor.new Formulary.factory(path), options
  end

  def test_init_no_problems
    fa = formula_auditor "foo", <<-EOS.undent
      class Foo < Formula
        url "http://example.com/foo-1.0.tgz"
      end
    EOS

    assert_equal [], fa.problems
  end

  def test_audit_file_permissions
    File.stubs(:umask).returns 022
    fa = formula_auditor "foo", <<-EOS.undent
      class Foo < Formula
        url "http://example.com/foo-1.0.tgz"
      end
    EOS

    path = fa.formula.path
    path.chmod 0400

    fa.audit_file
    assert_equal ["Incorrect file permissions (400): chmod 644 #{path}"],
      fa.problems
  end

  def test_audit_file_data_no_end
    fa = formula_auditor "foo", <<-EOS.undent
      class Foo < Formula
        url "http://example.com/foo-1.0.tgz"
        patch :DATA
      end
    EOS
    fa.audit_file
    assert_equal ["'DATA' was found, but no '__END__'"], fa.problems
  end

  def test_audit_file_end_no_data
    fa = formula_auditor "foo", <<-EOS.undent
      class Foo < Formula
        url "http://example.com/foo-1.0.tgz"
      end
      __END__
      a patch goes here
    EOS
    fa.audit_file
    assert_equal ["'__END__' was found, but 'DATA' is not used"], fa.problems
  end

  def test_audit_file_no_trailing_newline
    fa = formula_auditor "foo", 'class Foo<Formula; url "file:///foo-1.0.tgz";end'
    fa.audit_file
    assert_equal ["File should end with a newline"], fa.problems
  end

  def test_audit_file_not_strict_no_issue
    fa = formula_auditor "foo", <<-EOS.undent
      class Foo < Formula
        url "http://example.com/foo-1.0.tgz"
        homepage "http://example.com"
      end
    EOS
    fa.audit_file
    assert_equal [], fa.problems
  end

  def test_audit_file_strict_ordering_issue
    fa = formula_auditor "foo", <<-EOS.undent, :strict => true
      class Foo < Formula
        url "http://example.com/foo-1.0.tgz"
        homepage "http://example.com"
      end
    EOS
    fa.audit_file
    assert_equal ["`homepage` (line 3) should be put before `url` (line 2)"],
      fa.problems
  end

  def test_audit_file_strict_resource_placement
    fa = formula_auditor "foo", <<-EOS.undent, :strict => true
      class Foo < Formula
        url "https://example.com/foo-1.0.tgz"

        resource "foo2" do
          url "https://example.com/foo-2.0.tgz"
        end

        depends_on "openssl"
      end
    EOS
    fa.audit_file
    assert_equal ["`depends_on` (line 8) should be put before `resource` (line 4)"],
      fa.problems
  end

  def test_audit_file_strict_plist_placement
    fa = formula_auditor "foo", <<-EOS.undent, :strict => true
      class Foo < Formula
        url "https://example.com/foo-1.0.tgz"

        test do
          assert_match "Dogs are terrific", shell_output("./dogs")
        end

        def plist
        end
      end
    EOS
    fa.audit_file
    assert_equal ["`plist block` (line 8) should be put before `test block` (line 4)"],
      fa.problems
  end

  def test_audit_file_strict_url_outside_of_stable_block
    fa = formula_auditor "foo", <<-EOS.undent, :strict => true
      class Foo < Formula
        url "http://example.com/foo-1.0.tgz"
        stable do
          # stuff
        end
      end
    EOS
    fa.audit_file
    assert_equal ["`url` should be put inside `stable block`"], fa.problems
  end

  def test_audit_file_strict_head_and_head_do
    fa = formula_auditor "foo", <<-EOS.undent, :strict => true
      class Foo < Formula
        head "http://example.com/foo.git"
        head do
          # stuff
        end
      end
    EOS
    fa.audit_file
    assert_equal ["Should not have both `head` and `head do`"], fa.problems
  end

  def test_audit_file_strict_bottle_and_bottle_do
    fa = formula_auditor "foo", <<-EOS.undent, :strict => true
      class Foo < Formula
        url "http://example.com/foo-1.0.tgz"
        bottle do
          # bottles go here
        end
        bottle :unneeded
      end
    EOS
    fa.audit_file
    assert_equal ["Should not have `bottle :unneeded/:disable` and `bottle do`"],
      fa.problems
  end

  def test_audit_class_no_test
    fa = formula_auditor "foo", <<-EOS.undent
      class Foo < Formula
        url "http://example.com/foo-1.0.tgz"
      end
    EOS
    fa.audit_class
    assert_equal [], fa.problems

    fa = formula_auditor "foo", <<-EOS.undent, :strict => true
      class Foo < Formula
        url "http://example.com/foo-1.0.tgz"
      end
    EOS
    fa.audit_class
    assert_equal ["A `test do` test block should be added"], fa.problems
  end

  def test_audit_class_github_gist_formula
    needs_compat
    require "compat/formula_specialties"

    fa = formula_auditor "foo", <<-EOS.undent
      class Foo < GithubGistFormula
        url "http://example.com/foo-1.0.tgz"
      end
    EOS
    fa.audit_class
    assert_equal ["GithubGistFormula is deprecated, use Formula instead"],
      fa.problems
  end

  def test_audit_class_script_file_formula
    needs_compat
    require "compat/formula_specialties"

    fa = formula_auditor "foo", <<-EOS.undent
      class Foo < ScriptFileFormula
        url "http://example.com/foo-1.0.tgz"
      end
    EOS
    fa.audit_class
    assert_equal ["ScriptFileFormula is deprecated, use Formula instead"],
      fa.problems
  end

  def test_audit_class_aws_formula
    needs_compat
    require "compat/formula_specialties"

    fa = formula_auditor "foo", <<-EOS.undent
      class Foo < AmazonWebServicesFormula
        url "http://example.com/foo-1.0.tgz"
      end
    EOS
    fa.audit_class
    assert_equal ["AmazonWebServicesFormula is deprecated, use Formula instead"],
      fa.problems
  end

  def test_audit_line_pkgshare
    fa = formula_auditor "foo", <<-EOS.undent, :strict => true
      class Foo < Formula
        url "http://example.com/foo-1.0.tgz"
      end
    EOS
    fa.audit_line 'ohai "#{share}/foo"', 3
    assert_equal "Use \#{pkgshare} instead of \#{share}/foo", fa.problems.shift

    fa.audit_line 'ohai "#{share}/foo/bar"', 3
    assert_equal "Use \#{pkgshare} instead of \#{share}/foo", fa.problems.shift

    fa.audit_line 'ohai share/"foo"', 3
    assert_equal 'Use pkgshare instead of (share/"foo")', fa.problems.shift

    fa.audit_line 'ohai share/"foo/bar"', 3
    assert_equal 'Use pkgshare instead of (share/"foo")', fa.problems.shift

    fa.audit_line 'ohai "#{share}/foo-bar"', 3
    assert_equal [], fa.problems
    fa.audit_line 'ohai share/"foo-bar"', 3
    assert_equal [], fa.problems
    fa.audit_line 'ohai share/"bar"', 3
    assert_equal [], fa.problems
  end

  # Regression test for https://github.com/Homebrew/homebrew/pull/48744
  # Formulae with "++" in their name would break various audit regexps:
  #   Error: nested *?+ in regexp: /^libxml++3\s/
  def test_audit_plus_plus_name
    fa = formula_auditor "foolibc++", <<-EOS.undent, :strict => true
      class Foolibcxx < Formula
        desc "foolibc++ is a test"
        url "http://example.com/foo-1.0.tgz"
      end
    EOS

    fa.audit_desc
    assert_equal "Description shouldn't include the formula name",
      fa.problems.shift

    fa.audit_line 'ohai "#{share}/foolibc++"', 3
    assert_equal "Use \#{pkgshare} instead of \#{share}/foolibc++", fa.problems.shift

    fa.audit_line 'ohai share/"foolibc++"', 3
    assert_equal 'Use pkgshare instead of (share/"foolibc++")', fa.problems.shift
  end

  def test_audit_line_space_in_class_inheritance
    fa = formula_auditor "foo", "class Foo<Formula; url '/foo-1.0.tgz'; end"
    fa.audit_line "class Foo<Formula", 1
    assert_equal "Use a space in class inheritance: class Foo < Formula",
      fa.problems.shift
  end

  def test_audit_line_default_template
    fa = formula_auditor "foo", "class Foo < Formula; url '/foo-1.0.tgz'; end"

    fa.audit_line '# system "cmake", ".", *std_cmake_args', 3
    assert_equal "Commented cmake call found",
      fa.problems.shift

    fa.audit_line "# PLEASE REMOVE", 3
    assert_equal "Please remove default template comments",
      fa.problems.shift
  end
end
