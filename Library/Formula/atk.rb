require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.4/atk-2.4.0.tar.xz'
  sha256 '091e9ce975a9fbbc7cd8fa64c9c389ffb7fa6cdde58b6d5c01b2c267093d888d'

  devel do
    url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.5/atk-2.5.4.tar.xz'	
    sha256 'af6d6d8ec4543f338bf2476974de69891b7419913dd1cf4a94d53696bcc14aab'
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def options
    [["--universal", "Builds a universal binary"]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=no"
    system "make"
    system "make install"
  end
end
