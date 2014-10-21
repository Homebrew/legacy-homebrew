require "formula"

class LibgpgError < Formula
  homepage "http://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.16.tar.bz2"
  mirror "http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.16.tar.bz2"
  sha1 "059c40a2b78c3ac2b4cbec0e0481faba5af332fe"

  bottle do
    cellar :any
    revision 1
    sha1 "b584fbdd6545806f82a8c9c396513255a603c31b" => :yosemite
    sha1 "e45588e22aafc220fd4b742d6bf0941a84b65389" => :mavericks
    sha1 "3323b912b2f40994b18f0fccae8506839d883cbe" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
