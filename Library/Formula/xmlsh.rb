require 'formula'

class Xmlsh < Formula
  homepage 'http://www.xmlsh.org'
  url 'http://downloads.sourceforge.net/project/xmlsh/xmlsh/1.2.4/xmlsh_1_2_4.zip'
  sha1 'ef11e6fa3d72d99b78331a4ab58a22b1ad08b4ef'

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash

      # Used to set up classpaths
      #
      #   Bash default variable values syntax:
      #   http://wiki.bash-hackers.org/syntax/pe#use_a_default_value
      XMLSH=${XMLSH:-#{libexec}} && export XMLSH

      # Use XDG_CONFIG_HOME if it exists;
      # Otherwise HOME
      CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME}

      # Set up
      XMLSHRC=${CONFIG_HOME}/.xmlshrc

      # Execute unix script
      ${XMLSH}/unix/xmlsh -rcfile ${XMLSHRC}
    EOS
  end

  def install
    libexec.install Dir["*"]

    # remove windows files
    system "rm", "-rf", "#{libexec}/win32",  "#{libexec}/cygwin"

    # make the unix executable...um, executable.
    system "chmod", "a+x", "#{libexec}/unix/xmlsh"

    # Write mini-script to run as executable instead of `jar blah blah...`
    (bin/'xmlsh').write shim_script('xmlsh')
  end
end
