require 'formula'

class Nylon < Formula
  url 'http://monkey.org/~marius/nylon/nylon-1.21.tar.gz'
  sha1 '96f82a785ffe92fd6c1eebb69787327eecc90569'
  homepage 'http://monkey.org/~marius/pages/?page=nylon'

  depends_on 'libevent'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libevent=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
