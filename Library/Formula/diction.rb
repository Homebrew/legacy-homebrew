require 'formula'

class Diction < Formula
  url 'http://ftpmirror.gnu.org/diction/diction-1.11.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/diction/diction-1.11.tar.gz'
  homepage 'http://www.gnu.org/software/diction/'
  sha1 '30c7c778959120d30fa67be9261d41de894f498b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
