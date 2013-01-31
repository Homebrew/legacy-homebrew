require 'formula'

class Avce00 < Formula
  homepage 'http://avce00.maptools.org/avce00/index.html'
  url 'http://avce00.maptools.org/dl/avce00-2.0.0.tar.gz'
  sha1 '2948d9b1cfb6e80faf2e9b90c86fd224617efd75'

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "avcimport",  "avcexport", "avcdelete", "avctest"
  end
end
