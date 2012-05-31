require 'formula'

class Wwwoffle < Formula
  homepage 'http://www.gedanken.demon.co.uk/wwwoffle/'
  url 'http://www.gedanken.demon.co.uk/download-wwwoffle/wwwoffle-2.9h.tgz'
  md5 'a1c93ad6aa4a5095f19ca9fc6b1a7227'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
