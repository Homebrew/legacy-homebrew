class TokyoCabinet < Formula
  desc "Lightweight database library"
  homepage "http://fallabs.com/tokyocabinet/"
  url "http://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz"
  mirror "http://ftp.de.debian.org/debian/pool/main/t/tokyocabinet/tokyocabinet_1.4.48.orig.tar.gz"
  sha256 "a003f47c39a91e22d76bc4fe68b9b3de0f38851b160bbb1ca07a4f6441de1f90"

  bottle do
    sha256 "f7a7d169e0605b21acf50c1db7a0dc71f21726956649c8ec6900c54df2d1cab7" => :mavericks
    sha256 "84f0bf2bd9502684cf277ac5dd5355e8e70b555a0e45163d19f7b6cd7a87cf00" => :mountain_lion
    sha256 "3daa8b6caafa123dd9e8f3fa81d876187fc65f88ace3e35a4568e7844683b78b" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
