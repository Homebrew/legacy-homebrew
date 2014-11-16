require 'formula'

class Epubcheck < Formula
  homepage 'http://code.google.com/p/epubcheck/'
  url 'https://epubcheck.googlecode.com/files/epubcheck-3.0.1.zip'
  sha1 '80a61fb2817ec547d292362793da5b91dbef92e3'

  def install
    jarname = "epubcheck-#{version}.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, 'epubcheck'
  end
end
