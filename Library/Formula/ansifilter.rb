require 'formula'

class Ansifilter < Formula
  url 'http://www.andre-simon.de/zip/ansifilter-1.6.tar.bz2'
  homepage 'http://www.andre-simon.de/doku/ansifilter/ansifilter.html'
  sha1 '2b10c74d070fe440c56ee46dd065a38c536f8988'

  def install
    # both steps required and with PREFIX, last checked v1.6
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
