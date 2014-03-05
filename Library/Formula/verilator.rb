require 'formula'

class Verilator < Formula
  homepage 'http://www.veripool.org/wiki/verilator'
  url 'http://www.veripool.org/ftp/verilator-3.855.tgz'
  sha1 '2c37c48cdcb10674b5c9583a0d2b4f241dbb6dc4'

  skip_clean 'bin' # Allows perl scripts to keep their executable flag

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
