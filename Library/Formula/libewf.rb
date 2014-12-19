require "formula"

class Libewf < Formula
  homepage "http://code.google.com/p/libewf/"
  url "https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/libewf-20140608.tar.gz"
  sha1 "c17384a3d2c1d63bd5b1aaa2aead6ee3c82a2368"
  revision 1

  bottle do
    cellar :any
    sha1 "3a5b2ae9cedd50aca714dacc91716b845922e9fe" => :yosemite
    sha1 "077829c293b2da99c076a6328e7e96837103fe6c" => :mavericks
    sha1 "b3d3877c1683b551badb8a21491faceb27958cf1" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
