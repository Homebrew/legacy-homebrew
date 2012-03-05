require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/meld/1.5/meld-1.5.3.tar.xz'
  md5 '30e70ecd0689f2ae29a10656cdf33056'


  depends_on 'pygtk'
  depends_on 'pygobject'
  depends_on 'scrollkeeper'

  def install
    system "make prefix=#{prefix} install"
  end

end
