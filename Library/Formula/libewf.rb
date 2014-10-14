require "formula"

class Libewf < Formula
  homepage "http://code.google.com/p/libewf/"
  url "https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/libewf-20140608.tar.gz"
  sha1 "c17384a3d2c1d63bd5b1aaa2aead6ee3c82a2368"

  bottle do
    cellar :any
    sha1 "b1fabc308e90d9972da6d63076946ddd7f28d43f" => :mavericks
    sha1 "f44554f885887404ae2f6d7e124d775706f61d45" => :mountain_lion
    sha1 "a64fca272567e8cfad605b4fd8423fd90fe075b7" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
