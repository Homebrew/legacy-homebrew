require 'formula'

class Pcre < Formula
  homepage 'http://www.pcre.org/'
  url 'https://downloads.sourceforge.net/project/pcre/pcre/8.36/pcre-8.36.tar.bz2'
  mirror 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.36.tar.bz2'
  sha256 'ef833457de0c40e82f573e34528f43a751ff20257ad0e86d272ed5637eb845bb'

  bottle do
    cellar :any
    sha1 "71073c438d54caa2acc16026c947876c88ce2b80" => :yosemite
    sha1 "be65f007b73eeede8b965c0d7fc1c3d1a4bce087" => :mavericks
    sha1 "a0358dc5793923703258bd6a4fb9e5a5e44a358e" => :mountain_lion
    sha1 "6f7043ff5e9ad854dfe98e0399045d0f62209402" => :lion
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

  test do
    system "#{bin}/pcregrep", "regular expression", "#{prefix}/README"
  end
end
