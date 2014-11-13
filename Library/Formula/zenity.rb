require 'formula'

class Zenity < Formula
  homepage 'http://live.gnome.org/Zenity'
  url 'http://ftp.gnome.org/pub/gnome/sources/zenity/2.32/zenity-2.32.1.tar.gz'
  sha1 '41f323f88299618cefdde03fce95b283e5d81c8b'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'libxml2'
  depends_on 'gtk+'
  depends_on 'gnome-doc-utils'
  depends_on 'scrollkeeper'

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
