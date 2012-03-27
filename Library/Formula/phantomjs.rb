require 'formula'

class NeedsSnowLeopardOrNewer < Requirement
  def satisfied?
    MacOS.snow_leopard?
  end

  def message
    "phantomjs requires Mac OS X 10.6 (Snow Leopard) or newer."
  end
end

class Phantomjs < Formula
  url "http://phantomjs.googlecode.com/files/phantomjs-1.5.0-macosx-static.zip"
  homepage 'http://www.phantomjs.org/'
  sha1 'b87152ce691e7ed1937d30f86bc706a408d47f64'
  
  depends_on NeedsSnowLeopardOrNewer.new

  def install
    bin.install "bin/phantomjs"
  end
end
