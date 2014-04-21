require 'formula'

class Vala < Formula
  homepage 'http://live.gnome.org/Vala'
  url 'http://ftp.gnome.org/pub/gnome/sources/vala/0.23/vala-0.23.3.tar.xz'
  sha1 '77496e829f49b0b718ffc72fe2be8893f8b09f5d'

  head 'git://git.gnome.org/vala'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make install"
  end

  test do
    system "#{bin}/valac", "--version"
  end
end
