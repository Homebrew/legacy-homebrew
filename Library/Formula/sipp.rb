require 'formula'

class Sipp < Formula
  homepage 'http://sipp.sourceforge.net/'
  url "https://downloads.sourceforge.net/project/sipp/sipp/3.4/sipp-3.3.990.tar.gz"
  sha1 "b2637cb72556595253bbdd4a68cc974c9ac1d92e"

  depends_on "openssl" => :optional

  def install
    args = ["--with-pcap"]
    args << "--with-openssl" if build.with? "openssl"
    system "./configure", *args
    system "make", "DESTDIR=#{prefix}"
    bin.install "sipp"
  end
end
