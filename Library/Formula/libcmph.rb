class Libcmph < Formula
  desc "C minimal perfect hashing library"
  homepage "http://cmph.sourceforge.net"
  url "https://downloads.sourceforge.net/project/cmph/cmph/cmph-2.0.tar.gz"
  sha256 "ad6c9a75ff3da1fb1222cac0c1d9877f4f2366c5c61c92338c942314230cba76"

  bottle do
    cellar :any
    revision 1
    sha256 "4dba37edbd9ec4f32fcb911cbec5cbd457001c3f6a26f14a3ff88a412a42f017" => :yosemite
    sha256 "ba56f5d7f7c750329312dbf4d43d5d937320082ab32fe35ec84b05aecff125ee" => :mavericks
    sha256 "af52629547db4cef5a17fb5c4b46b8da9f165e9a9aed4bdd7f87d43d37e65687" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
