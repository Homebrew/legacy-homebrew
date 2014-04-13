require 'formula'

class Pcre < Formula
  homepage 'http://www.pcre.org/'
  url 'https://downloads.sourceforge.net/project/pcre/pcre/8.35/pcre-8.35.tar.bz2'
  mirror 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.35.tar.bz2'
  sha256 'a961c1c78befef263cc130756eeca7b674b4e73a81533293df44e4265236865b'

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
