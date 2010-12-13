require 'formula'

class IcarusVerilog <Formula
  url 'ftp://ftp.icarus.com/pub/eda/verilog/v0.9/verilog-0.9.2.tar.gz'
  homepage 'http://www.icarus.com/eda/verilog/'
  md5 'e3b3409f0a7aa382c0bfbb019655f647'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
