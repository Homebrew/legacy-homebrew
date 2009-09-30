require 'brewkit'

class Openssl <Formula
  url 'http://www.openssl.org/source/openssl-1.0.0-beta3.tar.gz'
  homepage 'http://www.openssl.org'
  md5 'cf5a32016bb9da0b9578099727bf15c9'

  def keg_only?; true end

  def install
    ENV.deparallelize
    system "./Configure", "darwin64-x86_64-cc", "shared", "zlib-dynamic", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats
    "Please note, OS X provides openssl, this is a slightly newer beta version"
  end
end
