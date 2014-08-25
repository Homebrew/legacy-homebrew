require "formula"

class Sipp < Formula
  homepage "http://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp/archive/v3.4.1.tar.gz"
  sha1 "40a3a7b7549e578997a8f181e557c3cdae39474f"
  revision 1

  bottle do
    cellar :any
    sha1 "dc471780c5e177836ccb96db84e1e4fa8b6705c3" => :mavericks
    sha1 "aa455a648623d4f957bb64212168d54de4b26d64" => :mountain_lion
    sha1 "2604f0f6244059520d4421c52a1d65f3be6e0ae2" => :lion
  end

  depends_on "openssl" => :optional

  def install
    args = ["--with-pcap"]
    args << "--with-openssl" if build.with? "openssl"
    system "./configure", *args
    system "make", "DESTDIR=#{prefix}"
    bin.install "sipp"
  end
end
