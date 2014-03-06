require "formula"

class Lhasa < Formula
  homepage "http://fragglet.github.io/lhasa/"
  url "https://github.com/fragglet/lhasa/archive/v0.2.0.tar.gz"
  sha1 "95dae252410648f629b275dedef218f81b835b3b"
  head "https://github.com/fragglet/lhasa.git"

  conflicts_with "lha", :because => "both install a `lha` binary"

  depends_on "pkg-config" => :build
  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    str = "MQAtbGgwLQQAAAAEAAAA9ZQTUyACg2JVBQAA" +
          "hloGAAFmb28FAFCkgQcAURQA9QEAAGZvbwoA"
    system "echo #{str} | /usr/bin/base64 -D | #{bin}/lha x -"
    assert_equal "foo\n", `cat foo`
  end
end
