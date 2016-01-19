class JsdocToolkit < Formula
  desc "Generate documentation from JavaScript source code"
  homepage "https://code.google.com/p/jsdoc-toolkit/"
  url "https://jsdoc-toolkit.googlecode.com/files/jsdoc_toolkit-2.4.0.zip"
  sha256 "82c79957b37b193bc64cc4363220517f1c76700863f1430aef8c94ecd4917b44"

  bottle :unneeded

  conflicts_with "jsdoc3", :because => "both install jsdoc"

  def install
    system "/bin/echo '#!/bin/ksh\nJSDOCDIR=\"#{libexec}/jsdoc-toolkit\"' > jsdoc"
    system "/usr/bin/grep -v \"^echo \\$CMD$\" jsdoc-toolkit/jsrun.sh >> jsdoc"

    bin.install "jsdoc"
    libexec.install "jsdoc-toolkit"
  end
end
