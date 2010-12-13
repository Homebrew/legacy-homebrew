require 'formula'

class Msgpack <Formula
  url 'http://downloads.sourceforge.net/project/msgpack/msgpack/cpp/msgpack-0.4.3.tar.gz'
  homepage 'http://msgpack.sourceforge.net/'
  md5 'ae55b5a48221fabc587a9ff2b0b6106e'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
