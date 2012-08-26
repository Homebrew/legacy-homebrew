require 'formula'

class JsdocToolkit < Formula
  homepage 'http://code.google.com/p/jsdoc-toolkit/'
  url 'https://jsdoc-toolkit.googlecode.com/files/jsdoc_toolkit-2.4.0.zip'
  sha1 'bd276ec58dbd419326760226174eba09810d26ee'

  def install
    system "/bin/echo '#!/bin/ksh\nJSDOCDIR=\"#{libexec}/jsdoc-toolkit\"' > jsdoc"
    system "/usr/bin/grep -v \"^echo \\$CMD$\" jsdoc-toolkit/jsrun.sh >> jsdoc"

    bin.install 'jsdoc'
    libexec.install 'jsdoc-toolkit'
  end
end
