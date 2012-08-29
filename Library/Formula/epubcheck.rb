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
    if ARGV.build_devel?
      libexec.install "epubcheck-3.0b5.jar", "lib"
      (bin/'epubcheck').write <<-EOS.undent
        #!/bin/sh
        java -jar "#{libexec}/epubcheck-3.0b5.jar" "$@"
      EOS
    else
      libexec.install "epubcheck-1.2.jar", "lib"
      (bin/'epubcheck').write <<-EOS.undent
        #!/bin/sh
        java -jar "#{libexec}/epubcheck-1.2.jar" "$@"
      EOS
    end
  end

  def test
    puts <<-EOS.undent
      To test epubcheck, find a epub file that doesn't have any errors and then:
        epubcheck file.epub

      The reply should look like:
        Epubcheck Version 1.2 or 3.0b5

        No errors or warnings detected
    EOS
  end
end