require 'formula'

class Magit < Formula
  homepage 'https://github.com/magit/magit'
  url 'https://github.com/magit/magit/archive/1.2.1.tar.gz'
  sha1 '3faeaab35934951a746e3be834d0457ca99bdc01'

  head 'https://github.com/magit/magit.git'

  def install
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end
end
