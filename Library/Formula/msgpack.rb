require 'formula'

class Msgpack <Formula
  url 'http://downloads.sourceforge.net/project/msgpack/msgpack/cpp/msgpack-0.5.4.tar.gz'
  homepage 'http://msgpack.sourceforge.net/'
  md5 '18d96a3178f7cad73c0ca44f6284ae7d'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
