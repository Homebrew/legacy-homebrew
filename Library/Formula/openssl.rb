require 'formula'

class Openssl <Formula
  url 'http://www.openssl.org/source/openssl-1.0.0d.tar.gz'
  version '1.0.0d'
  homepage 'http://www.openssl.org'
  md5 '40b6ea380cc8a5bf9734c2f8bf7e701e'

  keg_only :provided_by_osx

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.include? "--universal"
    ENV.j1 # Breaks on Mac Pro
    system "./config", "--prefix=#{prefix}",
                       "--openssldir=#{etc}",
                       "zlib-dynamic", "shared"
    system "make"
    system "make test"
    system "make install"
  end
end
