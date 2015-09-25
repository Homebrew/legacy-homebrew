class Lhasa < Formula
  desc "LHA implementation to decompress .lzh and .lzs archives"
  homepage "https://fragglet.github.io/lhasa/"
  url "https://github.com/fragglet/lhasa/archive/v0.3.0.tar.gz"
  sha256 "b9baae6508e6028a0cb871be7e4669be508542644382794d88d44744b9efdbe0"
  head "https://github.com/fragglet/lhasa.git"

  bottle do
    cellar :any
    sha256 "e165d272782133234ee3064fcb3dcac1923c3fe5d79891cb181619b6d8e79dde" => :yosemite
    sha256 "c7c28b850933f06b27a7af32a73a840437663aa334010eb097ecb7f3ff6dd4c1" => :mavericks
    sha256 "af8aac8f99b3cf42dde5e69d0f18e1e72370cde24b3b00fb1577fd5a99e54489" => :mountain_lion
  end

  conflicts_with "lha", :because => "both install a `lha` binary"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    str = "MQAtbGgwLQQAAAAEAAAA9ZQTUyACg2JVBQAA" \
          "hloGAAFmb28FAFCkgQcAURQA9QEAAGZvbwoA"
    system "echo #{str} | /usr/bin/base64 -D | #{bin}/lha x -"
    assert_equal "foo\n", `cat foo`
  end
end
