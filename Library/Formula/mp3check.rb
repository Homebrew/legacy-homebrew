require 'formula'

class Mp3check < Formula
  homepage 'http://code.google.com/p/mp3check/'
  url 'https://mp3check.googlecode.com/files/mp3check-0.8.7.tgz'
  sha1 '31fe95bb7949343f6ebc04fcaa2faffd2b738264'

  def install
    ENV.deparallelize
    # The makefile's install target is kinda iffy, but there's
    # only one file to install so it's easier to do it ourselves
    system "make"
    bin.install 'mp3check'
  end
end
