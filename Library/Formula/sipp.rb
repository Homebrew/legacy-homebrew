class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "http://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp/archive/v3.4.1.tar.gz"
  sha256 "bb6829a1f3af8d8b5f08ffcd7de40e2692b4dfb9a83eccec3653a51f77a82bc4"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "dd4040ea2070600b2b43dbeed1118e54c7e3a084c545684e082759f288147884" => :mavericks
    sha256 "c271b9d4851ce5af31def30c0058b927f6694e2e5247978126db009b0b32d339" => :mountain_lion
    sha256 "f5a95ee2f72b167b3f769cf0ad13a117f787e5e03569a9a769c7bfa1b8783b89" => :lion
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
