require 'formula'

class MsgpackRpc < Formula
  homepage 'https://github.com/msgpack/msgpack-rpc'
  url 'http://msgpack.org/releases/cpp/msgpack-rpc-0.3.1.tar.gz'
  sha1 'd11328592bc142863a4e03d86471064a3a0881d3'

  depends_on 'msgpack'
  depends_on 'mpio'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
