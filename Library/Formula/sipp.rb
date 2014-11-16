require "formula"

class Sipp < Formula
  homepage "http://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp/archive/v3.4.1.tar.gz"
  sha1 "40a3a7b7549e578997a8f181e557c3cdae39474f"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "850972e13e3498f4b02f0d7f8cfcf52a57e9061d" => :mavericks
    sha1 "7090284509ca0e0c94ccf8ed807bee34a7c03679" => :mountain_lion
    sha1 "aaf2d525f601b20aab098ca164e4161113996666" => :lion
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
