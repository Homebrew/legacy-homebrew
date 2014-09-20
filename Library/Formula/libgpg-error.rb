require "formula"

class LibgpgError < Formula
  homepage "http://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.16.tar.bz2"
  mirror "http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.16.tar.bz2"
  sha1 "059c40a2b78c3ac2b4cbec0e0481faba5af332fe"

  bottle do
    cellar :any
    sha1 "c9d320a135686d2dccef6328a7d9b926ba04db2a" => :mavericks
    sha1 "5fa28dbea7cf575256f8c7d801f5c162af1b948d" => :mountain_lion
    sha1 "e934e5ef48e6d87c06324cb5e50637cd979d2bc5" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
