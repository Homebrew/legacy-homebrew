require 'formula'

class St < Formula
  homepage 'https://github.com/nferraz/st'
  url 'https://github.com/nferraz/st/archive/v1.0.1.tar.gz'
  sha1 '832d58c991aef86c14683f578a7fd1297a20e4f7'
  head 'https://github.com/nferraz/st.git'

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}", "INSTALLMAN1DIR=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "st"
    system "st examples/basic.txt"
    system "st examples/mixed.txt"
  end
end
