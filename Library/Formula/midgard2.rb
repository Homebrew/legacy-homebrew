require 'formula'

class Midgard2 < Formula
  homepage 'http://www.midgard-project.org/'
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://www.midgard-project.org/midcom-serveattachmentguid-b459b3e443f711e0a6353dc3bca0241a241a/midgard2-core-10.05.4.tar.gz'
  md5 '99dcf5d5e39901712a882598e3da17d2'
=======
  url 'https://github.com/downloads/midgardproject/midgard-core/midgard2-core-10.05.7.1.tar.gz'
  sha1 'c9e8930492056f7ca714a043296250fdd9ef4c66'

  head 'https://github.com/midgardproject/midgard-core.git', :branch => 'ratatoskr'
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
  url 'https://github.com/downloads/midgardproject/midgard-core/midgard2-core-10.05.7.1.tar.gz'
  sha1 'c9e8930492056f7ca714a043296250fdd9ef4c66'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  head 'https://github.com/midgardproject/midgard-core.git', :branch => 'ratatoskr'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'dbus-glib'
  depends_on 'libgda'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    if ARGV.build_head?
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
