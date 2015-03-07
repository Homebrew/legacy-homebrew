require 'formula'

class Gtkx < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.25.tar.xz'
  sha256 '38af1020cb8ff3d10dda2c8807f11e92af9d2fa4045de61c62eedb7fbc7ea5b3'

  bottle do
    sha1 "0316a3ac6d961ab3fb69bbce61ff2eff93a17181" => :yosemite
    sha1 "24b4dc55e528bf0d970f9e1a097a8b647a6c91bd" => :mavericks
    sha1 "e6ff2911ff5d77feb0f4e9b8f39b0c51d6717429" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk'
  depends_on 'cairo'
  depends_on :x11 => ['2.3.6', :recommended]
  depends_on 'gobject-introspection'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--disable-glibtest",
            "--enable-introspection=yes",
            "--disable-visibility"]

    args << "--with-gdktarget=quartz" if build.without?("x11")
    args << "--enable-quartz-relocation" if build.without?("x11")

    system "./configure", *args
    system "make install"
  end
end
