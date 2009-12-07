require 'formula'

class Sdcc <Formula
  url 'http://downloads.sourceforge.net/project/sdcc/sdcc/2.8.0/sdcc-src-2.8.0.tar.bz2'
  homepage 'http://sdcc.sourceforge.net/'
  md5 '1b9c2e581b92d5e3f13bca37c5784080'

  def install
    ENV.O3 # You don't want to see what happens with -O4.

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
