require 'formula'

class Mergelog < Formula
  homepage 'http://mergelog.sourceforge.net/'
  url 'https://downloads.sourceforge.net/mergelog/mergelog-4.5.tar.gz'
  sha1 'bc9bdfddc561301e417a2de949ce3c4203b54c94'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/mergelog", "/dev/null"
  end
end
