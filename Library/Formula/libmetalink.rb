class Libmetalink < Formula
  desc "C library to parse Metalink XML files"
  homepage "https://launchpad.net/libmetalink/"
  url "https://launchpad.net/libmetalink/trunk/libmetalink-0.1.3/+download/libmetalink-0.1.3.tar.xz"
  sha256 "86312620c5b64c694b91f9cc355eabbd358fa92195b3e99517504076bf9fe33a"

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
