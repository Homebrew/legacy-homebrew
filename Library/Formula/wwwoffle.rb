require 'formula'

class Wwwoffle < Formula
  homepage 'http://www.gedanken.demon.co.uk/wwwoffle/'
  url 'http://www.gedanken.demon.co.uk/download-wwwoffle/wwwoffle-2.9h.tgz'
  sha1 '14b30fd66ca8a95e90489323fb6ade3ffd60ad49'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
