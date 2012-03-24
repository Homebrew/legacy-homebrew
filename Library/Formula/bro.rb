require 'formula'

class Bro < Formula
  url 'http://www.bro-ids.org/downloads/release/bro-2.0.tar.gz'
  homepage 'http://www.bro-ids.org/'
  md5 '2ea82a7b4cabf3ff70e26085494e527f'

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
