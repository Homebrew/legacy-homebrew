require "formula"

class Verilator < Formula
  homepage "http://www.veripool.org/wiki/verilator"
  url "http://www.veripool.org/ftp/verilator-3.860.tgz"
  sha1 "ed53584854e7b2f1d0e8b52c0d4ae0018f35000c"

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
