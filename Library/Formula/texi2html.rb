require 'formula'

class Texi2html < Formula
  homepage 'http://www.nongnu.org/texi2html/'
  url 'http://download.savannah.gnu.org/releases/texi2html/texi2html-1.70.tar.gz'
  sha1 'b3472fb5ef80824177a56a1a37983c13497b23be'

  keg_only :provided_by_osx unless MacOS.mountain_lion?

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--mandir=#{man}", "--infodir=#{info}"
    system "make install"
  end

  def test
    system "#{bin}/texi2html", "--help"
  end
end
