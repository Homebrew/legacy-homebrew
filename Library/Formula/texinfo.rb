require 'formula'

class Texinfo < Formula
  homepage 'http://www.gnu.org/software/texinfo/'
  url 'http://ftpmirror.gnu.org/texinfo/texinfo-5.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/texinfo/texinfo-5.1.tar.gz'
  sha1 '8b642aea2f5ba8a1ba4b15f438a47c1d15dcd214'

  keg_only :provided_by_osx, <<-EOS.undent
    Software that uses TeX, such as lilypond and octave, require a newer version
    of these files.
  EOS

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make install"

    # The install warns about needing to install texinfo.tex and some other support files.
    # The texinfo.tex in tex-live 2008 is identical to texinfo's version, so we can ignore this.

    # However, it complains about installing epsf.tex in TEXMF/tex/generic/dvips, so let's do that...
    # This somewhat breaks the homebrew philosophy, I am sorry.
    # Also, we don't depend on tex-live, but this directory only exists if it is installed.
    if File.exist? "#{HOMEBREW_PREFIX}/share/texmf-dist/" then
      system "cp", "doc/epsf.tex", "#{HOMEBREW_PREFIX}/share/texmf-dist/tex/generic/dvips/"
    end
  end
end
