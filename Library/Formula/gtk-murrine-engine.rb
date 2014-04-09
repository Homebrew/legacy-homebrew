require 'formula'

class GtkMurrineEngine < Formula
  homepage 'https://github.com/GNOME/murrine'
  url 'http://ftp.gnome.org/pub/GNOME/sources/murrine/0.98/murrine-0.98.2.tar.xz'
  sha1 'ddaca56b6e10736838572014ae9d20b814242615'

  depends_on 'intltool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-animation"
    system "make", "install"
  end
end
