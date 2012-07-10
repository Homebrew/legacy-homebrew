require 'formula'


class Xmlsh < Formula
  homepage 'http://www.xmlsh.org'
  url 'http://downloads.sourceforge.net/project/xmlsh/xmlsh/1.2.0/xmlsh_1_2_0.zip'
  sha1 '999cff2dd41778924f26ea558d6a684c6988173d'
  version '1.2.0'

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash

      # Use XDG_CONFIG_HOME if it exists
      XDG_CONFIG_HOME=$XDG_CONFIG_HOME || $HOME || ( echo "ERROR IN STARTUP SCRIPT!"; exit 1 )
      #{self.libexec}/unix/xmlsh -rcfile ${XDG_CONFIG_HOME}/.xmlshrc

    EOS
  end


  # @TODO
  #   Look at maven.rb formula for example of installing
  #   things like README, LICENSE, etc. to the #{prefix}
  #   directory.


  def install
    libexec.install Dir["*"]

    # the provided executable is, by default...uh, not executable.
    system "chmod", "a+x", "#{self.libexec}/unix/xmlsh"

    # remove windows files
    system "rm", "-rf", "#{self.libexec}/win32",  "#{self.libexec}/cygwin"

    # Write mini-script to run as executable instead of `jar blah blah...`
    (bin + 'xmlsh').write shim_script('xmlsh')
  end


  def caveats; <<-EOS.undent
    This package uses the Java JLine library <jline.sourceforge.net>
    for command line editing.  It is known to be buggy on some (possible most)
    OS X systems.

    In spite of this, 'xmlsh' is still a powerful tool for working XML.  Using
    '*.xsh' scripts is also a workaround (somewhat...) to dealing with the
    command line editing bugs.
    EOS
  end


  def test
    system "xmlsh", "#{self.libexec}/test/run_tests.xsh"
  end

end
