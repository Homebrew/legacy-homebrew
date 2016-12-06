require 'formula'

class St < Formula
  homepage 'https://github.com/nferraz/st'
  url 'https://github.com/nferraz/st/archive/v1.0.2.tar.gz'
  sha1 '9b7c0c197d3b7724d317e9a9afb55d67b1082259'
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
