require 'formula'

class Oorexx < Formula
  url 'http://downloads.sourceforge.net/project/oorexx/oorexx/4.0.0/ooRexx-4.0.0.tar.gz'
  homepage 'http://www.oorexx.org/'
  sha1 '944336a5488ea82b69409d1d3cf28e0d5b32cadc'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
