require 'formula'

class Kumofs < Formula
  url 'https://github.com/downloads/etolabo/kumofs/kumofs-0.4.12.tar.gz'
  head 'git://github.com/etolabo/kumofs.git'
  homepage 'http://kumofs.sourceforge.net/'
  md5 '70fc53a332fb2b76ae6a3aad7aa59aad'

  depends_on 'tokyo-cabinet'
  # msgpack rubygem and the C++ lib are needed
  depends_on 'msgpack'
  depends_on 'msgpack' => :ruby

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-msgpack=#{prefix}",
                          "--with-tokyocabinet=#{prefix}"
    system "make install"
  end
end
