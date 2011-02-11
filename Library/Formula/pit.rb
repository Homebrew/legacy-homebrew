require 'formula'

class Pit < Formula
  url 'https://download.github.com/michaeldv-pit-0.1.0-5-g3e35117.tar.gz'
  version '0.1.0-5'
  homepage 'http://github.com/michaeldv/pit'
  md5 '9c4aa317ded18b32fb299c2fd4424ef8'

  def install
    bin.mkpath
    (prefix+'bin').mkpath

    system "make"
    system "make install PREFIX=#{prefix}"
  end
end
