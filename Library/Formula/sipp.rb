require 'formula'

class Sipp < Formula
  homepage 'http://sipp.sourceforge.net/'
  url "https://github.com/SIPp/sipp/archive/v3.4.1.tar.gz"
  sha1 "40a3a7b7549e578997a8f181e557c3cdae39474f"

  depends_on "openssl" => :optional

  def install
    args = ["--with-pcap"]
    args << "--with-openssl" if build.with? "openssl"
    system "./configure", *args
    system "make", "DESTDIR=#{prefix}"
    bin.install "sipp"
  end
end
