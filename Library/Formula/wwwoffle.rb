require 'formula'

class Wwwoffle < Formula
  homepage 'http://www.gedanken.org.uk/software/wwwoffle/'
  url 'http://www.gedanken.org.uk/software/wwwoffle/download/wwwoffle-2.9i.tgz'
  sha1 'f9a9d39b88047ff2728a9d4c60accbe5da3ec3cc'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
