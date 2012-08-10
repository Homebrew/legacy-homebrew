require 'formula'

class Shocco < Formula
  homepage 'http://rtomayko.github.com/shocco/'
  url 'https://github.com/rtomayko/shocco/tarball/a5bddd08ec'
  sha1 'f581bbf52a4981ce2c7cf97910169d3d9d498305'
  version '20111210'
  
  head 'https://github.com/rtomayko/shocco.git'

  depends_on 'markdown'
  depends_on 'pygments' => :python

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "shocco"
  end

  def caveats
    <<-EOS.undent
      You may also want to install browser:
        brew install browser
        shocco `which shocco` | browser
    EOS
  end
end
