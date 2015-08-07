class Libestr < Formula
  desc "C library for string handling (and a bit more)"
  homepage "http://libestr.adiscon.com"
  url "http://libestr.adiscon.com/files/download/libestr-0.1.9.tar.gz"
  sha256 "822c6e2d01eaca1e72201f403a2ca01f3e86410b880e508e5204e3c2694d751a"

  bottle do
    cellar :any
    revision 1
    sha1 "6527f1d2444b2d9b77977bdd445425930bbcc172" => :yosemite
    sha1 "d419d2e778300f56e5ec8b473c436c12e0d81920" => :mavericks
    sha1 "3561f90f17cb8d8b339b8c0f7ead0a17b5bbe243" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
