require 'formula'

class Magit < Formula
  url 'https://github.com/downloads/magit/magit/magit-1.0.0.tar.gz'
  homepage 'https://github.com/magit/magit'
  md5 '1f640741ff0cf94ea84c607fac8758d6'
  head 'git://github.com/magit/magit.git'

  def install
    system "./autogen.sh" if File.exist? "autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
