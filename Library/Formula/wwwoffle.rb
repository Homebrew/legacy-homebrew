require 'formula'

class Wwwoffle < Formula
  url 'http://www.gedanken.demon.co.uk/download-wwwoffle/wwwoffle-2.9f.tgz'
  homepage 'http://www.gedanken.demon.co.uk/wwwoffle/'
  md5 'a5f04c190a2f27f28cfc744c478e6aaa'
  version '2.9f'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
