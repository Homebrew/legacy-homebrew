require 'formula'

class Antlr < Formula
  version '3.3'
  url "http://www.antlr.org/download/antlr-#{version}-complete.jar"
  homepage 'http://www.antlr.org/'
  md5 '238becce7da69f7be5c5b8a65558cf63'

  def install
    prefix.install "antlr-#{version}-complete.jar"
    #Add an executable shell-script
    (bin + "antlr-#{version}").write "#!/bin/sh\njava -jar #{prefix}/antlr-#{version}-complete.jar $*"
  end
end
