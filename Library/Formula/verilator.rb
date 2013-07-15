require 'formula'

class Verilator < Formula
  homepage 'http://www.veripool.org/wiki/verilator'
  url 'http://www.veripool.org/ftp/verilator-3.833.tgz'
  sha1 '4ca58d609371b0a6309c5564a5e8ba6857aa15db'

  skip_clean 'bin' # Allows perl scripts to keep their executable flag

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
