require 'formula'

class Magit < Formula
  url 'https://github.com/downloads/magit/magit/magit-1.0.0.tar.gz'
  homepage 'https://github.com/magit/magit'
  sha1 '58773e84870d9d8d1138619e1f3928d1696aa168'
  head 'https://github.com/magit/magit.git'

  def install
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end
end
