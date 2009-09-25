require 'brewkit'

class Openssl <Formula
  url 'http://www.openssl.org/source/openssl-1.0.0-beta3.tar.gz'
  homepage 'http://www.openssl.org'
  md5 'cf5a32016bb9da0b9578099727bf15c9'

  def keg_only?; true end

  def install
    ENV.deparallelize
    config_flags = ["shared", "zlib-dynamic", "--prefix=#{prefix}"]
    config_flags << if Hardware.is_64_bit? and MACOS_VERSION == 10.6
      "darwin64-x86_64-cc" 
    else
      "darwin-i386-cc"
    end
    system "./Configure", *config_flags
    system "make"
    system "make install"
  end

  def caveats
    "Please note, OS X provides openssl, this is a slightly newer beta version"
  end
end
