require 'formula'

class Phantomjs < Formula
  url "http://phantomjs.googlecode.com/files/phantomjs-1.5.0-macosx-static.zip"
  homepage 'http://www.phantomjs.org/'
  sha1 'b87152ce691e7ed1937d30f86bc706a408d47f64'

  def install
    bin.install "bin/phantomjs"
  end
end
