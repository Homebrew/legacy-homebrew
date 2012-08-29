require 'formula'

class Dasm < Formula
  homepage 'http://dasm-dillon.sourceforge.net'
  url 'http://sourceforge.net/projects/dasm-dillon/files/dasm-dillon/2.20.11/dasm-2.20.11.tar.gz'
  md5 '3e67f7b8ac80419d53cc0aaa9a47ab37'

  def install
    system "make"
    prefix.install Dir['bin']
  end
end
