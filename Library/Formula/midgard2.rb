require 'formula'

class Midgard2 < Formula
  desc "Generic content repository for web and desktop applications"
  homepage 'http://www.midgard-project.org/'
  url 'https://github.com/downloads/midgardproject/midgard-core/midgard2-core-12.09.tar.gz'
  sha1 'dc5f21833b4a9ba9e714dd523a563b7e6ee777af'

  head do
    url 'https://github.com/midgardproject/midgard-core.git', :branch => 'ratatoskr'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'dbus-glib'
  depends_on 'libgda'

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-libgda5
      --with-dbus-support
      --enable-introspection=no
    ]

    if build.head?
      inreplace 'autogen.sh', 'libtoolize', 'glibtoolize'
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make install"
  end
end
