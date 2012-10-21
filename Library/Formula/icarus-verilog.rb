require 'formula'

class IcarusVerilog < Formula
  homepage 'http://iverilog.icarus.com/'
  url 'ftp://icarus.com/pub/eda/verilog/v0.9/verilog-0.9.5.tar.gz'
  sha1 '3a69cb935ab562882a07a52904f3cba74aed2229'

  devel do
    url 'ftp://ftp.icarus.com/pub/eda/verilog/snapshots/verilog-20120501.tar.gz'
    sha1 '313ab0f5dc4d198bd4687daaf2e54749c67558b3'
  end

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
