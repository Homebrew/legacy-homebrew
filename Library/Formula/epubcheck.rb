require 'formula'

class Epubcheck < Formula
  homepage 'http://code.google.com/p/epubcheck/'
  url 'http://epubcheck.googlecode.com/files/epubcheck-1.2.zip'
  sha1 '86036eadad8408070791b3da368958239ed8a410'

  devel do
    url 'http://epubcheck.googlecode.com/files/epubcheck-3.0b5.zip'
    sha1 'd5f9d60733f587946fc853f561ca2f13e3b8f83d'
  end

  def install
    jarname = build.devel? ? "epubcheck-3.0b5.jar" : "epubcheck-1.2.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, 'epubcheck'
  end
end
