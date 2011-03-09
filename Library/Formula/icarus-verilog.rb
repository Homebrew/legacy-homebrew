require 'formula'

class IcarusVerilog <Formula
  url 'ftp://ftp.icarus.com/pub/eda/verilog/v0.9/verilog-0.9.3.tar.gz'
  homepage 'http://www.icarus.com/eda/verilog/'
  md5 'd004408ea595b13780c4c036f8188b66'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
