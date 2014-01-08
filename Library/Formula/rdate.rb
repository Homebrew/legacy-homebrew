require 'formula'

class Rdate < Formula
  homepage 'http://www.aelius.com/njh/rdate/'
  url 'http://www.aelius.com/njh/rdate/rdate-1.5.tar.gz'
  sha1 'd7212503907db741ab53c4dd13ed141702d1809b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
