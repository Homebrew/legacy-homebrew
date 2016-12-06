require 'formula'

class Keybinder < Formula
  homepage 'http://kaizer.se/wiki/keybinder/'
  url 'http://kaizer.se/publicfiles/keybinder/keybinder-0.2.2.tar.gz'
  md5 'b4ccd4bd19f3ae3f0ab2cbda11fcd3ac'

   depends_on 'pygtk'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    system "python", "-c", "\"import keybinder\""
  end
end
