require 'formula'

class Bro < Formula
  homepage 'http://www.bro-ids.org/'
  url 'http://www.bro-ids.org/downloads/release/bro-2.1.tar.gz'
  sha1 'c000a19831d46ecd448e1ec40ed84abfcf496b6f'

  depends_on 'cmake' => :build
  depends_on 'swig' => :build
  depends_on 'libmagic'

  def install
    # Ruby bindings not building for me on 10.6 - @adamv
    system "./configure", "--prefix=#{prefix}",
                          "--disable-ruby"
    system "make install"
  end
end
