require 'formula'

class Muscle < Formula
  url 'http://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_src.tar.gz'
  homepage 'http://www.drive5.com/muscle/'
  md5 'f767f00fd15f0c5db944d41936779e10'
  version '3.8.31'

  def install
    system "cd src/; make"
    system "mkdir "+bin
    system "cp src/muscle "+bin+"/"
  end
end
