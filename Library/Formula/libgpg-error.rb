class LibgpgError < Formula
  homepage "http://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.18.tar.bz2"
  mirror "http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.18.tar.bz2"
  sha1 "7ba54f939da023af8f5b3e7a421a32eb742909c4"

  bottle do
    cellar :any
    sha1 "ea42085dd9d363cfad2facb61777018255168cb0" => :yosemite
    sha1 "d3f1915a8a549edadbf40f6bcedd83b4559d8286" => :mavericks
    sha1 "57d378b5a7a2d1617e908b7ac81408ea918214b3" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
