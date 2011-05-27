require 'formula'

class Msgpack < Formula
  homepage 'http://msgpack.org/'
  url 'http://msgpack.org/releases/cpp/msgpack-0.5.6.tar.gz'
  sha256 '4d4a2b50955e35b6b8e92247ee079467b3294db2378d5bc73e83c9bbe184545b'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
