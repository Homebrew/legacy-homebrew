require 'formula'

class Calabash < Formula
  homepage 'http://xmlcalabash.com'
  url 'http://xmlcalabash.com/download/calabash-0.9.40.zip'
  md5 'e9cea3e4fe6cd3c9dba6cb886fda4743'
  head 'https://github.com/ndw/xmlcalabash1.git'


  def install
    libexec.install Dir["*"]
    (bin+'calabash').write shim_script('calabash')
  end


  #
  # Copied & modified from `brew cat saxon`
  #
  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
      java -Xmx1024m -jar #{libexec}/calabash.jar "$@"
    EOS

    # NOTE
    #
    #   The download comes a "bin" directory and an executable.
    #   Unfortunately, I don't know how to tell Homebrew to use
    #   it (or whether that's a good idea).
    #
    #   Please let me know how to do this (and whether it's a good
    #   idea)!  Message me on GitHub (I'm "Zearin").
    #
    #   (In the meantime, the code above worked for me.)
  end

  def test
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "calabash #{self.prefix}/libexec/xpl/pipe.xpl"
  end
end