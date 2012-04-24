require 'formula'

class T < Formula
  homepage 'http://github.com/sferik/t'
  url 'https://github.com/sferik/t/tarball/v0.6.2'
  head 'https://sferik@github.com/sferik/t.git'
  md5 '70067100a81cc9b2f6ae82b89dbd629f'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
