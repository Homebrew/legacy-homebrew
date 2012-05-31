require 'formula'

class Magit < Formula
  url 'https://github.com/downloads/magit/magit/magit-1.0.0.tar.gz'
  homepage 'https://github.com/magit/magit'
  md5 '1f640741ff0cf94ea84c607fac8758d6'
  head 'https://github.com/magit/magit.git'

  def install
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end
end
