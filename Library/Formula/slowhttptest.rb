class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://slowhttptest.googlecode.com/files/slowhttptest-1.6.tar.gz"
  sha256 "77c54a64cfa5f12a84729833d9b98d5f27f828f51a5e42ad5914482d0b2bd0d6"
  head "https://github.com/shekyan/slowhttptest.git"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "1c212418f652bf3eddb611ad3835f23e9fa4db4765bf3f81aaf7ef75f3cecd26" => :el_capitan
    sha256 "5f21db1a90ad47e8f6bcc5844990e85aa01292b14a5caa4efeb824e8a5f4e12e" => :yosemite
    sha256 "e91ca04130138fd89494f8f3fce5218f55333b910ece008cedd54bfac5de42be" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", *%w[-u https://google.com -p 1 -r 1 -l 1 -i 1]
  end
end
