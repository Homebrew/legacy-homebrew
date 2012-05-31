require 'formula'

class Fontconfig < Formula
  url 'http://fontconfig.org/release/fontconfig-2.8.0.tar.gz'
  homepage 'http://fontconfig.org/'
  md5 '77e15a92006ddc2adbb06f840d591c0e'

  keg_only :provided_by_osx,
    "Leopard comes with version 2.4.x, which is too old for many packages."

  depends_on 'pkg-config' => :build

  def install
    ENV.x11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
