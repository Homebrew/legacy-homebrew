require 'formula'

class Msktutil < Formula
  homepage 'https://code.google.com/p/msktutil/'
  url 'https://msktutil.googlecode.com/files/msktutil-0.5.tar.bz2'
  sha1 '2f00acabd7a98f4ad5be2dd88f3f52349f658bb7'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
