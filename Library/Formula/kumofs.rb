require 'formula'

class Kumofs <Formula
  url 'http://github.com/downloads/etolabo/kumofs/kumofs-0.4.8.tar.gz'
  head 'git://github.com/etolabo/kumofs.git'
  homepage 'http://kumofs.sourceforge.net/'
  md5 '8ce7bc91f86bb7e43b66cbf11af37a99'

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
