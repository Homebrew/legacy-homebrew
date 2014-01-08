require 'formula'

class Ansifilter < Formula
  homepage 'http://www.andre-simon.de/doku/ansifilter/ansifilter.html'
  url 'http://www.andre-simon.de/zip/ansifilter-1.7.tar.bz2'
  sha1 '5b88db508ea100f327bf6b621c959742694fe2d8'

  def install
    # both steps required and with PREFIX, last checked v1.7
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
