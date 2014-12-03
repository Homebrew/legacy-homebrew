require "formula"

class Realpath < Formula
  homepage "https://packages.debian.org/sid/realpath"
  url "http://ftp.debian.org/debian/pool/main/r/realpath/realpath_1.18.tar.gz"
  sha1 "fbaf38d28ca1072921411c17ddd05a7681152397"

  depends_on "gettext"

  def install
    gettext = Formula['gettext'].prefix
    system "make",
      %Q[CPPFLAGS=-I#{gettext/"include"} -DVERSION='"#{version}"' -DPACKAGE='"realpath"' -DLOCALEDIR='"#{share}/locale"'],
      "LDFLAGS=-L#{gettext/"lib"}",
      "LDLIBS=-lintl",
      "VERSION=#{version}",
      "src/realpath"
    bin.install "src/realpath"
  end

  test do
    system "#{bin}/realpath --version"
    mkdir "foo"
    ln_s "foo", "bar"
    assert_equal "#{testpath}/foo\n", `#{bin}/realpath bar`
  end
end
