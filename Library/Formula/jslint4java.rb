require 'formula'

class Jslint4java < Formula
  homepage 'http://code.google.com/p/jslint4java/'
  url 'http://jslint4java.googlecode.com/files/jslint4java-2.0.3-dist.zip'
  sha1 'd92f29e4f2055c4f945b398a602349afa14c26ca'

  def install
    doc.install Dir['docs/*']
    libexec.install Dir['*.jar']
    bin.write_jar_script Dir[libexec/'jslint4java*.jar'].first, 'jslint4java'
  end
end
