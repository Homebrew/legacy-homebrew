require 'formula'

class Openssl < Formula
  url 'http://www.openssl.org/source/openssl-0.9.8r.tar.gz'
  version '0.9.8r'
  homepage 'http://www.openssl.org'
  md5 '0352932ea863bc02b056cda7c9ac5b79'

  keg_only :provided_by_osx,
            "OpenSSL provided by Leopard is too old for newer software to link against."

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    ENV.j1 # Breaks on Mac Pro
    system "./config", "--prefix=#{prefix}",
                       "--openssldir=#{etc}",
                       "zlib-dynamic", "shared"
    system "make"
    system "make test"
    system "make install"
  end
end
