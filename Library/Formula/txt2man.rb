require 'formula'

class Txt2man < Formula
  homepage 'http://mvertes.free.fr/'
  url 'http://mvertes.free.fr/download/txt2man-1.5.6.tar.gz'
  sha1 'ef1392785333ea88f7e01f4f4c519ecfbdd498bd'

  depends_on 'gawk'

  def install
    # No config script; change prefix in Makefile
    # Also hack the non-existent MANPATH variable
    inreplace 'Makefile' do |s|
      s.change_make_var! "prefix", prefix
      s.gsub! "/man/man1", "/share/man/man1"
    end

    system "make install"
  end

  def test
    system "#{bin}/txt2man", "-h"
    system "#{bin}/src2man", "-h"
    system "#{bin}/bookman", "-h"
  end
end
