require 'formula'

class Epubcheck < Formula
  homepage 'http://code.google.com/p/epubcheck/'
  url 'http://epubcheck.googlecode.com/files/epubcheck-1.2.zip'
  sha1 '86036eadad8408070791b3da368958239ed8a410'

  def install
    libexec.install "epubcheck-1.2.jar", "lib"
    (bin/'epubcheck').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/epubcheck-1.2.jar" "$@"
    EOS
  end

  def test
    puts <<-EOS.undent
      To test epubcheck, find a epub file that doesn't have any errors and then:
        epubcheck file.epub

      The reply should look like:
        Epubcheck Version 1.2

        No errors or warnings detected
    EOS
  end
end
