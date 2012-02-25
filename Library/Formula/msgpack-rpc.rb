require 'formula'

class MsgpackRpc < Formula
  url 'http://msgpack.org/releases/cpp/msgpack-rpc-0.3.1.tar.gz'
  homepage 'https://github.com/msgpack/msgpack-rpc'
  md5 'e5e8f3631ac83d20cdf65fa0d7bfee21'

  depends_on 'msgpack'
  depends_on 'mpio'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
