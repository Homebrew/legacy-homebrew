class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "http://homepage.boetes.org/software/mg/"
  url "http://homepage.boetes.org/software/mg/mg-20131118.tar.gz"
  sha256 "b99fe10cb8473e035ff43bf3fbf94a24035e4ebb89484d48e5b33075d22d79f3"

  depends_on "clens"

  def install
    # makefile hardcodes include path to clens; since it's a
    # nonstandard path, Homebrew's standard include paths won't
    # fix this for people with nonstandard prefixes.
    # Note mg also has a Makefile; but MacOS make uses GNUmakefile
    inreplace "GNUmakefile", "$(includedir)/clens", "#{Formula["clens"].opt_include}/clens"

    system "make"
    bin.install "mg"
    doc.install "tutorial"
    man1.install "mg.1"
  end
end
