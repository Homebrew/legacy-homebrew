require 'formula'

class Convmv < Formula
  homepage 'http://www.j3e.de/linux/convmv/'
  url 'http://www.j3e.de/linux/convmv/convmv-1.15.tar.gz'
  sha1 '7ca8599a37480a99058c4498fba7cfed64134de5'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
