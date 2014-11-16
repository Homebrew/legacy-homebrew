require 'formula'

class Bbe < Formula
  homepage 'http://bbe-.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/bbe-/bbe/0.2.2/bbe-0.2.2.tar.gz'
  sha1 '42d5b47d607a9633fb49e7d39e2aebfb7bb89c05'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
