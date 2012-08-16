require 'formula'

class Texi2html < Formula
  homepage 'http://www.nongnu.org/texi2html/'
  url 'http://download.savannah.gnu.org/releases/texi2html/texi2html-5.0.tar.bz2'
  sha1 '20072444ce814d0e74fd7e467d1506908f8c889c'

  keg_only :provided_by_osx unless MacOS.mountain_lion?

  def install
    # The install-sh, used if ginstall is not present, isn't executable!
    chmod 0744, "install-sh"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "texi2html", "--help"
  end
end
