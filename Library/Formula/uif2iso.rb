require 'formula'

class Uif2iso < Formula
  homepage 'http://aluigi.org/mytoolz.htm#uif2iso'
  url 'http://aluigi.org/mytoolz/uif2iso.zip'
  md5 '2eb9797ec463c38253014d45591a7043'
  version '0.1.7c'

  def install
    system "make -C src"
    system "make", "-C", "src", "prefix=#{prefix}", "install"
  end
end
