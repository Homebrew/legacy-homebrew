require 'formula'

class IcarusVerilog < Formula
  homepage 'http://iverilog.icarus.com/'
  url 'ftp://icarus.com/pub/eda/verilog/v0.9/verilog-0.9.6.tar.gz'
  sha1 'd81f586b801a2d897ba8c35971d660b960220ed4'

  def install
    # Fixes an assertion when XCode-4.4 tries to link with clang or llvm-gcc.
    ENV['LD'] = MacOS.locate("ld")
    system "./configure", "--prefix=#{prefix}"
    # Separate steps, as install does not depend on compile properly
    system 'make'
    system 'make installdirs'
    system 'make install'
  end
end
