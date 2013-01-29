require 'formula'

class Kumofs < Formula
  homepage 'http://kumofs.sourceforge.net/'
  url 'https://github.com/downloads/etolabo/kumofs/kumofs-0.4.12.tar.gz'
  sha1 'a1e895e42c8d5d75233f2234cf55069e76b4d39b'

  head 'https://github.com/etolabo/kumofs.git'

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
