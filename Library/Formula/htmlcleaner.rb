require 'formula'

class Htmlcleaner < Formula
  homepage 'http://htmlcleaner.sourceforge.net/index.php'
  url 'http://downloads.sourceforge.net/projects/htmlcleaner/files/htmlcleaner/htmlcleaner%20v2.6.1/htmlcleaner-2.6.1.zip'
  version '2.6.1'
  sha1 '4c5d2049c7048dc6632a17ec15e21ab0fcf510b9'

  def install
    prefix.install "htmlcleaner-2.6.1.jar"
    (bin+"htmlcleaner").write <<-EOS.undent
      #!/bin/sh
      java -jar "#{prefix}/htmlcleaner-2.6.1.jar" "$@"
    EOS
  end
end
