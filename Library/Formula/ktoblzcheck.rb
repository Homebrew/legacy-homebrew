require 'formula'

class Ktoblzcheck < Formula
  homepage 'http://ktoblzcheck.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.39.tar.gz'
  sha1 'b88ae800ed4cf7a1b8547eb0104fc6663334716d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
