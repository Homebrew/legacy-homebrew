require 'formula'

class IcarusVerilog < Formula
  homepage 'http://iverilog.icarus.com/'
  url 'ftp://icarus.com/pub/eda/verilog/v0.9/verilog-0.9.5.tar.gz'
  md5 '3eaeafbb8f0f36765676ab1aaa0fe330'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
