require 'formula'

class Libdaemon < Formula
  url 'http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz'
  homepage 'http://0pointer.de/lennart/projects/libdaemon/'
  sha1 '78a4db58cf3a7a8906c35592434e37680ca83b8f'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
