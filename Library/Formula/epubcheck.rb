require 'formula'

class Epubcheck < Formula
  homepage 'http://code.google.com/p/epubcheck/'
  url 'http://epubcheck.googlecode.com/files/epubcheck-1.2.zip'
  sha1 '86036eadad8408070791b3da368958239ed8a410'

  devel do
    url 'http://epubcheck.googlecode.com/files/epubcheck-3.0-RC-1.zip'
    version '3.0-RC-1'
    sha1 '055d8aaaaee70c581aced379097bb1eb1e7a8826'
  end

  def install
    jarname = build.devel? ? "epubcheck-3.0-RC-1.jar" : "epubcheck-1.2.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, 'epubcheck'
  end
end
