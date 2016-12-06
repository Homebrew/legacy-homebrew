require 'formula'

class Pandoc < Formula
  homepage 'http://johnmacfarlane.net/pandoc/'
  #url 'https://github.com/jgm/pandoc/tarball/1.9.1.1'
  #md5 'dd3a8c2c3005fa13687a7ba11d3b8477'
  url 'http://pandoc.googlecode.com/files/pandoc-1.9.1.1.tar.gz'
  md5 '8e596946c1c8982c1b5a6bdc4d13b5a0'
  head 'https://github.com/jgm/pandoc.git'

  depends_on 'cabal-install' => :build

  def install
    system "cabal", "update"
    system "cabal", "install", "--prefix=#{prefix}"
  end

end
