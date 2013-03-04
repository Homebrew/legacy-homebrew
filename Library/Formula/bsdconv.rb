# encoding: UTF-8

require 'formula'

class Bsdconv < Formula
  homepage 'https://github.com/buganini/bsdconv'
  url 'https://github.com/buganini/bsdconv/tarball/9.1'
  sha1 '282fa6f2bcb6ef3b73f19ef269ecc917edcde729'

  head 'https://github.com/buganini/bsdconv.git'

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def test
    printf = 'printf "\263\134\245\134\273\134"'
    system "test `#{printf} | #{bin}/bsdconv big5:utf-8` = '許功蓋'"
  end
end
