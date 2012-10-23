require 'formula'

class Midgard2 < Formula
  homepage 'http://www.midgard-project.org/'
  url 'https://github.com/downloads/midgardproject/midgard-core/midgard2-core-10.05.7.1.tar.gz'
  sha1 'c9e8930492056f7ca714a043296250fdd9ef4c66'

  head 'https://github.com/midgardproject/midgard-core.git', :branch => 'ratatoskr'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'dbus-glib'
  depends_on 'libgda'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    if build.head?
      system "autoreconf", "-i", "--force"
      system "automake"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libgda4",
                          "--with-dbus-support",
                          "--enable-introspection=no"
    system "make install"
  end
end
