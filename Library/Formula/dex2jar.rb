require 'formula'

class Dex2jar < Formula
  url 'http://dex2jar.googlecode.com/files/dex-translator-0.0.9.3.zip'
  homepage 'http://code.google.com/p/dex2jar/'
  md5 '1b77866a91127f11701bd8b6ca7bbfcb'

  def install
    libexec.install Dir['lib']
    (bin/:dex2jar).write <<-EOS.undent
      #!/bin/sh
      _classpath="."
      for k in #{libexec}/lib/*.jar
      do
       _classpath="${_classpath}:${k}"
      done
      java -Xms512m -Xmx1024m -classpath "${_classpath}" "com.googlecode.dex2jar.v3.Main" $1 $2 $3 $4 $5 $6
    EOS
  end
end
