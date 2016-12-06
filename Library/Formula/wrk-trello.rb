require 'formula'

class WrkTrello < Formula
  homepage 'https://github.com/blangel/wrk'
  url 'http://cloud.github.com/downloads/blangel/wrk/wrk-1.0.1.tar.gz'
  sha1 'a1dc3c2cac173a8a4b2e0270edb91855be17a735'

  def script; <<-EOS.undent
    #!/bin/sh

    export WRK_HOME=#{libexec}
    #{libexec}/bin/wrk "$@"
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

