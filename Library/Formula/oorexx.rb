require 'formula'

class Oorexx < Formula
  homepage 'http://www.oorexx.org/'
  url 'http://downloads.sourceforge.net/project/oorexx/oorexx/4.0.0/ooRexx-4.0.0.tar.gz'
  sha1 '944336a5488ea82b69409d1d3cf28e0d5b32cadc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
