require 'formula'

class Gocode < Formula
  head 'https://github.com/nsf/gocode.git'
  url 'https://github.com/nsf/gocode.git', :tag => 'compatible-with-go-release.r57'
  homepage 'https://github.com/nsf/gocode'
  
  version 'r57'
  
  def install
    system "make"
    bin.mkpath
    bin.install "gocode"
  end
end
