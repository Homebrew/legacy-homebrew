require 'formula'

class IcarusVerilog < Formula
  homepage 'http://iverilog.icarus.com/'
  head 'https://github.com/steveicarus/iverilog.git'
  url 'ftp://icarus.com/pub/eda/verilog/v0.9/verilog-0.9.7.tar.gz'
  sha1 '714c2a605779957490cca24e3dc01d096dbc1474'

  if build.head?
    depends_on 'autoconf' => :build
  end

  def install
    # Fixes an assertion when XCode-4.4 tries to link with clang or llvm-gcc.
    ENV['LD'] = MacOS.locate("ld")
    # Generate configure for head build
    if build.head?
      system "autoconf"
    end
    # Configure
    system "./configure", "--prefix=#{prefix}"
    # Separate steps, as install does not depend on compile properly
    system 'make'
    system 'make installdirs'
    system 'make install'
  end
end
