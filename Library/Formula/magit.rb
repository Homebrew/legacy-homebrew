require 'formula'

class Magit < Formula
  homepage 'https://github.com/magit/magit'
  url 'https://github.com/magit/magit/archive/1.2.0.tar.gz'
  sha1 '8ad7947a29d4d852f35f94a6821d038fe43a7c31'

  head 'https://github.com/magit/magit.git'

  def install
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end
end
