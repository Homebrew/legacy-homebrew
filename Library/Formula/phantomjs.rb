require 'formula'

class SnowLeopardOrNewer < Requirement
  def satisfied?
    MacOS.snow_leopard?
  end

  def message
    "PhantomJS requires Mac OS X 10.6 (Snow Leopard) or newer."
  end
end

class Phantomjs < Formula
  homepage 'http://www.phantomjs.org/'
  url "http://phantomjs.googlecode.com/files/phantomjs-1.5.0-macosx-static.zip"
  sha1 'b87152ce691e7ed1937d30f86bc706a408d47f64'

  depends_on SnowLeopardOrNewer.new

  # phantomjs wrapper script to hide dock icon
  # See http://code.google.com/p/phantomjs/issues/detail?id=281
  def script; <<-EOS.undent
    #!/bin/sh
    exec "#{libexec}/phantomjs" "$@"
    EOS
  end

  def install
    libexec.install 'bin/phantomjs', 'bin/Info.plist'
    (bin+'phantomjs').write script
  end
end
