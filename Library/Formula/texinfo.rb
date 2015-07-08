class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "http://www.gnu.org/software/texinfo/"
  url "http://ftpmirror.gnu.org/texinfo/texinfo-5.2.tar.gz"
  mirror "http://ftp.gnu.org/gnu/texinfo/texinfo-5.2.tar.gz"
  sha1 "dc54edfbb623d46fb400576b3da181f987e63516"

  bottle do
    sha1 "988fc8c195a43ad8b9dea1da2827fb24c794c200" => :yosemite
    sha1 "40453ac408ede2cb5470935a5c5d2360f64032b5" => :mavericks
    sha1 "1ac4d9ac120248a5b71cb45199c01bad850a7655" => :mountain_lion
  end

  keg_only :provided_by_osx, <<-EOS.undent
    Software that uses TeX, such as lilypond and octave, require a newer version
    of these files.
  EOS

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"

    # The install warns about needing to install texinfo.tex and some other support files.
    # The texinfo.tex in tex-live 2008 is identical to texinfo's version, so we can ignore this.

    # However, it complains about installing epsf.tex in TEXMF/tex/generic/dvips, so let's do that...
    # This somewhat breaks the homebrew philosophy, I am sorry.
    # Also, we don't depend on tex-live, but this directory only exists if it is installed.
    if File.exist? "#{HOMEBREW_PREFIX}/share/texmf-dist/" then
      cp "doc/epsf.tex", "#{HOMEBREW_PREFIX}/share/texmf-dist/tex/generic/dvips/"
    end
  end

  test do
    (testpath/"test.texinfo").write <<-EOS.undent
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/makeinfo", "test.texinfo"
    assert_match /Hello World!/, File.read("test.info")
  end
end
