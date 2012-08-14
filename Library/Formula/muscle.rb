require 'formula'

class Muscle < Formula
  homepage 'http://www.drive5.com/muscle/'
  url 'http://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_src.tar.gz'
  version '3.8.31'
  md5 'f767f00fd15f0c5db944d41936779e10'

  def install
    cd "src" do
      system "make"
      bin.install "muscle"
    end
  end
end
