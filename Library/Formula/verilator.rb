require "formula"

class Verilator < Formula
  homepage "http://www.veripool.org/wiki/verilator"
  url "http://www.veripool.org/ftp/verilator-3.862.tgz"
  sha1 "dd5d3f13478b51b0bd7d37ed353fcf58a6e774e1"

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  # Needs a newer flex on Lion (and presumably below)
  # http://www.veripool.org/issues/720-Verilator-verilator-not-building-on-Mac-OS-X-Lion-10-7-
  depends_on "flex" if MacOS.version <= :lion

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
