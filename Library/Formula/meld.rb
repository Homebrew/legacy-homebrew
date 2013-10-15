require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/meld/1.8/meld-1.8.1.tar.xz'
  sha1 '58c14ee018fb7d21b1ad00a366b50c884de6b38f'

  depends_on 'intltool' => :build
  depends_on 'xz' => :build
  depends_on :x11
  depends_on 'pygtk'
  depends_on 'pygobject'
  depends_on 'rarian'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
