require 'formula'

class Libdaemon < Formula
  url 'http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz'
  homepage 'http://0pointer.de/lennart/projects/libdaemon/'
  md5 '509dc27107c21bcd9fbf2f95f5669563'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
