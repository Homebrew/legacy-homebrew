require 'formula'

class Jslint4java < Formula
  homepage 'http://code.google.com/p/jslint4java/'
  url 'http://jslint4java.googlecode.com/files/jslint4java-2.0.3-dist.zip'
  sha1 'd92f29e4f2055c4f945b398a602349afa14c26ca'

  def install
    libexec.install Dir['*']
    bin.write_jar_script libexec/'jslint4java-2.0.2.jar', 'jslint4java'
  end
end
