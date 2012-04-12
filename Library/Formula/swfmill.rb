require 'formula'

class Swfmill < Formula
  homepage 'http://swfmill.org'
  url 'http://swfmill.org/releases/swfmill-0.3.2.tar.gz'
  md5 'c607f8aba506ec32cc4423446fe6644e'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    # Has trouble linking against zlib unless we add it here - @adamv
    system "make", "LIBS=-lz", "install"
  end
end
