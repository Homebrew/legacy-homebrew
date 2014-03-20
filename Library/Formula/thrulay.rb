require 'formula'

class Thrulay < Formula
  homepage 'http://sourceforge.net/projects/thrulay/'
  url 'https://downloads.sourceforge.net/project/thrulay/thrulay/0.9/thrulay-0.9.tar.gz'
  sha1 '9128ebdd6b2213f5e166f9e1d95322161a3290f2'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1
    system "make install"
  end
end
