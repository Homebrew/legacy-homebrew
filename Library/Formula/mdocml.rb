require "formula"

class Mdocml < Formula
  homepage "http://mdocml.bsd.lv"
  url "http://mdocml.bsd.lv/snapshots/mdocml-1.12.3.tar.gz"
  sha1 "6a74b4e4b54a20b8022f05236e2294ad2915e5d7"

  def install
    system "make", "prefix=#{prefix}", "STATIC="
    bin.install "mandoc", "preconv", "demandoc"
    man1.install "mandoc.1", "preconv.1", "demandoc.1"
    man3.install "tbl.3", "mandoc.3"
    man7.install "tbl.7", "roff.7", "eqn.7", "mandoc_char.7", "mdoc.7"
    include.install "man.h", "mdoc.h", "mandoc.h"
    lib.install "libmandoc.a"
    (share/"examples/mandoc").install "example.style.css"
  end

  test do
    system "#{bin}/mandoc", "-V"
  end
end
