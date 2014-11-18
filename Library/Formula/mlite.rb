require 'formula'

class Mlite < Formula
  homepage 'http://t3x.org/mlite/index.html'
  url 'http://t3x.org/mlite/mlite-20141116.tgz'
  sha1 'bac7ff009848cafaa318585ad13446c89f08f84e'

  def install
    system "make", "CC=#{ENV.cc}"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
