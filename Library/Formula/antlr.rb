require 'formula'

class Antlr < Formula
  version '3.2'
  url "http://www.antlr.org/download/antlr-#{version}.jar"
  homepage 'http://www.antlr.org/'
  md5 'ee7dc3fb20cf3e9efd871e297c0d532b'

  def install
    prefix.install "antlr-#{version}.jar"
    #Add an executable shell-script
    (bin + "antlr-#{version}").write "#!/bin/sh\njava -jar #{prefix}/antlr-#{version}.jar $*"
  end
end