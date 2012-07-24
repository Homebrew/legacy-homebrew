require 'formula'

class Jasmin < Formula
  homepage 'http://jasmin.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/jasmin/jasmin/jasmin-2.4/jasmin-2.4.zip'
  sha1 'c66400680144e0da4efdcf4a084e42e2355189fe'

  def script; <<-EOS.undent
    #!/bin/sh
    # Jasmin wrapper script.

    java -jar "#{prefix}/jasmin.jar" "$@"
    EOS
  end

  def install
    # Remove Windows scripts
    rm_rf Dir['*.bat']

    prefix.install %w[Readme.txt license-ant.txt license-jasmin.txt jasmin.jar]
    (bin+"jasmin").write script
  end

  def test
    system "jasmin -version"
  end
end
