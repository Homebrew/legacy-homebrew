class SchemeInstalled < Requirement
  default_formula "gauche"
  fatal true

  satisfy { which("gsi") || which("gosh") || which("guile") }

  def message; <<-EOS.undent
    A Scheme implementation is required to use SLIB.

    You can install one of the SLIB supported Scheme
    implementation with Homebrew:
      brew install gambit-scheme
      brew install gauche
      brew install guile

    Or you can use one of several different prepackaged installers
    that are available.
    EOS
  end
end

class Slib < Formula
  homepage "http://people.csail.mit.edu/jaffer/SLIB"
  url "http://groups.csail.mit.edu/mac/ftpdir/scm/slib-3b4.zip"
  sha1 "dda1ed78ff7164738a1a8c51f1f7c08ec1db79eb"

  depends_on SchemeInstalled

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "infoz", "INSTALL_INFO=install-info"
    system "make", "install", "INSTALL_INFO=install-info"
  end

  test do
    success = false

    ENV["SCHEME_LIBRARY_PATH"] = "#{lib}/slib/"

    (testpath/"test.scm").write <<-EOS.undent
      (require 'new-catalog)
      (require 'format)
      (format #t "slib")
      (exit)
    EOS

    gambit_bin = which("gsi")
    unless gambit_bin.to_s == ""

      ENV["GAMBIT_IMPLEMENTATION_PATH"] = Formula["gambit-scheme"].prefix

      result = `#{gambit_bin} -:s ${SCHEME_LIBRARY_PATH}gambit.init #{testpath}/test.scm`
      assert_equal "slib", result
      success = true
    end

    gauche_bin = which("gosh")
    unless gauche_bin.to_s == ""

      (testpath/"test-gosh.scm").write <<-EOS.undent
        (use slib)
        (require 'format)
        (format #t "slib")
        (exit)
      EOS

      result = `#{gauche_bin} -l #{testpath}/test-gosh.scm`
      assert_equal "slib", result
      success = true
    end

    guile_bin = which("guile")
    unless guile_bin.to_s == ""
      ENV["GUILE_IMPLEMENTATION_PATH"] = Formula["guile"].prefix
      ENV["GUILE_WARN_DEPRECATED"] = "no"

      result = `#{guile_bin} -l ${SCHEME_LIBRARY_PATH}guile.init -l ${SCHEME_LIBRARY_PATH}guile.use test.scm`
      assert_equal "slib", result
      success = true
    end

    assert success, "No Scheme implementation is tested"
  end
end
