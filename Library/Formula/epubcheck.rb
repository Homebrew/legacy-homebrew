require 'formula'

class Epubcheck < Formula
  homepage 'http://code.google.com/p/epubcheck/'
  url 'http://epubcheck.googlecode.com/files/epubcheck-3.0.zip'
  sha1 'd4064f9c3ce1a82130897301374bc760ed69d55c'

  def install
    jarname = "epubcheck-#{version}.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, 'epubcheck'
  end
end
