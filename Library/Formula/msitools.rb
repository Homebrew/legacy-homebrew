require 'formula'

class Msitools < Formula
  homepage 'https://wiki.gnome.org/msitools'
  url 'http://ftp.gnome.org/pub/GNOME/sources/msitools/0.93/msitools-0.93.tar.xz'
  sha1 'b8dcf394a1aeddd8404ae1702ce42af623f54101'

  depends_on 'xz' => :build
  depends_on 'intltool' => :build
  depends_on 'pkg-config' => :build
  depends_on :automake => :build
  depends_on :autoconf => :build
  depends_on :libtool
  depends_on 'gcab'
  depends_on 'glib'
  depends_on 'vala'
  depends_on 'libgsf'
  depends_on 'e2fsprogs'
  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "msiinfo", "--help"
  end
end
