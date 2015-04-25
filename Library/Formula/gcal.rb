require 'formula'

class Gcal < Formula
  homepage 'https://www.gnu.org/software/gcal/'
  url 'http://ftpmirror.gnu.org/gcal/gcal-3.6.3.tar.xz'
  mirror 'https://ftp.gnu.org/gnu/gcal/gcal-3.6.3.tar.xz'
  sha1 'a5d68216d8b0735c9b095fb81a08d6dbf5cdeedd'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
