require 'formula'

class Ansifilter < Formula
  url 'http://www.andre-simon.de/zip/ansifilter-1.3.tar.bz2'
  homepage 'http://www.andre-simon.de/doku/ansifilter/ansifilter.html'
  sha1 'a57daa13261d01ea7df5f4787d1a7c44a8a2d3f2'

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
