class Libmetalink < Formula
  desc "C library to parse Metalink XML files"
  homepage "https://launchpad.net/libmetalink/"
  url "https://launchpad.net/libmetalink/trunk/packagingfix/+download/libmetalink-0.1.2.tar.bz2"
  sha256 "cbed9121bf550ef14a434d6ed3d8806ded7a339db16b698cfa2f39fdc3d48bf6"

  bottle do
    cellar :any
    revision 1
    sha1 "0fd4cd6106168e23a2ce691bcc3db3afaef44001" => :yosemite
    sha1 "3cbcf570dd17a7c617da687d1d90b20d03e9e299" => :mavericks
    sha1 "ceeab999a4e6b19c7859ffc8e4d0319cd365cb48" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
