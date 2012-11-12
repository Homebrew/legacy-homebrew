require 'formula'

class Jslint4java < Formula
  homepage 'http://code.google.com/p/jslint4java/'
  url "http://jslint4java.googlecode.com/files/jslint4java-2.0.2-dist.zip"
  sha1 'a632bc96c82dbaf11372f46649175e46bd0c3a47'

  def install
    libexec.install Dir['*']
    bin.write_jar_script libexec/'jslint4java-2.0.2.jar', 'jslint4java'
  end
end
