require 'formula'

class Mdxplay < Formula
  url 'http://homepage3.nifty.com/StudioBreeze/software/bin/mdxplay-20070206.tar.gz'
  homepage 'http://homepage3.nifty.com/StudioBreeze/software/mdxplay-e.html'
  md5 '94757a37c697aee8fbdab5ca2a0ab4f9'

  depends_on 'gettext'

  def install
    # Configure does not place -liconv in LIBS, resulting in missing symbols error
    inreplace 'configure', 'LIBS="-lintl $LIBS"', 'LIBS="-lintl -liconv $LIBS"'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end

  def test
    system "#{bin}/mdxplay -V"
  end
end
