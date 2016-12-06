require 'formula'

class TidyHtml5 < Formula
  homepage 'http://w3c.github.com/tidy-html5/'
  url 'https://github.com/w3c/tidy-html5/archive/master.zip'
  sha1 '288cd7fa58ef1fa626844dc3fa250b9d3a44abf7'
  version "20130103"

  def install
    ENV.deparallelize
    system "make -C build/gmake/"
    system "make install -C build/gmake"
  end

  def test
    tidy
  end
end
