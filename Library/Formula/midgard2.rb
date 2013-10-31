require 'formula'

class Midgard2 < Formula
  homepage 'http://www.midgard-project.org/'
  url 'https://github.com/downloads/midgardproject/midgard-core/midgard2-core-12.09.tar.gz'
  sha1 'dc5f21833b4a9ba9e714dd523a563b7e6ee777af'

  head do
    url 'https://github.com/midgardproject/midgard-core.git', :branch => 'ratatoskr'

    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'dbus-glib'
  depends_on 'libgda'

  def install
    if build.head?
      system "autoreconf", "-i", "--force"
      system "automake"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libgda5",
                          "--with-dbus-support",
                          "--enable-introspection=no"
    system "make install"
  end
end
