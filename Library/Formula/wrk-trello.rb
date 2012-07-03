require 'formula'

class WrkTrello < Formula
  homepage 'https://github.com/blangel/wrk'
  url 'http://surma-filedump.s3.amazonaws.com/wrk-1.0.tar.gz'
  sha1 '14aedc84b3ee0a348e7c4f511e1ec014a20590ee'

  def script; <<-EOS.undent
    #!/bin/sh

    export WRK_HOME=#{libexec}
    #{libexec}/bin/wrk $@
    EOS
  end

  def install
    libexec.install Dir['*']
    (bin+'wrk').write script
  end

  def caveats
    <<-EOS.undent
    To get your token go here:
    https://trello.com/1/authorize?key=8d56bbd601877abfd13150a999a840d0&name=Wrk&expiration=never&response_type=token&scope=read,write
    and save it to ~/.wrk/token
    (Start `wrk` for more information)
    EOS
  end
end

