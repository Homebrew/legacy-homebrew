class Lhasa < Formula
  desc "LHA implementation to decompress .lzh and .lzs archives"
  homepage "https://fragglet.github.io/lhasa/"
  url "https://github.com/fragglet/lhasa/archive/v0.2.0.tar.gz"
  sha256 "c26a60f9b0b728abf3b67b98b7baee52e1fedc9fd531866e58135f2587514d91"
  head "https://github.com/fragglet/lhasa.git"

  bottle do
    cellar :any
    sha1 "31020074660df16a6a8103ec7cc27e243d053d38" => :mavericks
    sha1 "b1758087df7ecdd4e206391c0fb6a6fa4d36bdc0" => :mountain_lion
    sha1 "ca05444eab009813f610815c319c91705bb397a1" => :lion
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
