require 'formula'

class JsdocToolkit <Formula
  url 'http://jsdoc-toolkit.googlecode.com/files/jsdoc_toolkit-2.3.2.zip'
  homepage 'http://code.google.com/p/jsdoc-toolkit/'
  sha1 'd8c3977cee202c06a9d6a85b2b9b068d21309fad'

  def install
    system "/bin/echo '#!/bin/ksh\nJSDOCDIR=\"#{libexec}/jsdoc-toolkit\"' > jsdoc"
    system "/usr/bin/grep -v \"^echo \\$CMD$\" jsdoc-toolkit/jsrun.sh >> jsdoc"

    bin.install 'jsdoc'
    libexec.install 'jsdoc-toolkit'
  end
end
