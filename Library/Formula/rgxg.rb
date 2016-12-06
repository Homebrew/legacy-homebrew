require 'formula'

class Rgxg < Formula
  homepage 'http://rgxg.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/rgxg/rgxg/rgxg-0.1.tar.gz'
  sha1 'c57ad6daae9bc1b706a1b641d8a3c3be5c9ae743'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
