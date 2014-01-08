require 'formula'

class Ktoblzcheck < Formula
  homepage 'http://ktoblzcheck.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.43.tar.gz'
  sha1 '9b03780f17c5e4ef6a821cd9d819cb39e4fb559f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
