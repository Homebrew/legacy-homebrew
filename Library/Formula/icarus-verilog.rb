require 'formula'

class IcarusVerilog < Formula
  homepage 'http://iverilog.icarus.com/'
  url 'ftp://icarus.com/pub/eda/verilog/v0.9/verilog-0.9.7.tar.gz'
  sha1 '714c2a605779957490cca24e3dc01d096dbc1474'

  head do
    url 'https://github.com/steveicarus/iverilog.git'
    depends_on 'autoconf' => :build
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    # Separate steps, as install does not depend on compile properly
    system 'make'
    system 'make installdirs'
    system 'make install'
  end
end
