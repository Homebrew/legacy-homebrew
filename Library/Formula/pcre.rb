require 'formula'

class Pcre < Formula
  homepage 'http://www.pcre.org/'
  url 'https://downloads.sourceforge.net/project/pcre/pcre/8.34/pcre-8.34.tar.bz2'
  mirror 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.34.tar.bz2'
  sha256 'b6043ae1ff2720be665ffa28dc22b7c637cdde96f389a116c0c3020caeae583f'

  bottle do
    cellar :any
    sha1 "ae800efb8807432a74d54b15a9b69418514b32c4" => :mavericks
    sha1 "0e703e2c93ad719661aa318748bc182f981ad434" => :mountain_lion
    sha1 "f9be8c9d11ce3f1ac4ea6ddf7adeb5c1a6e2e06a" => :lion
  end

  option :universal

  fails_with :llvm do
    build 2326
    cause "Bus error in ld on SL 10.6.4"
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8",
                          "--enable-pcre8",
                          "--enable-pcre16",
                          "--enable-pcre32",
                          "--enable-unicode-properties",
                          "--enable-pcregrep-libz",
                          "--enable-pcregrep-libbz2",
                          "--enable-jit"
    system "make"
    ENV.deparallelize
    system "make test"
    system "make install"
  end
end
