require 'formula'

class Uif2iso < Formula
  url 'http://aluigi.org/mytoolz/uif2iso.zip'
  homepage 'http://aluigi.org/mytoolz.htm#uif2iso'
  md5 '2eb9797ec463c38253014d45591a7043'
  version '0.1.7c'

  def install
    inreplace 'src/Makefile' do |s|
      s.change_make_var! "prefix", prefix
    end
    system "make -C src"
    system "make -C src install"
  end
end
