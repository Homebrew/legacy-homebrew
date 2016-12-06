require 'formula'
class Zlog < Formula
  homepage 'https://github.com/HardySimpson/zlog'
  url 'https://github.com/HardySimpson/zlog/archive/1.2.11.zip'
  sha1 '9be288dd518d83d48a52ca465778c1f56a00f322'

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
