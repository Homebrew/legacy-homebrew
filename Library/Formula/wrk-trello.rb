require 'formula'

class WrkTrello < Formula
  homepage 'https://github.com/blangel/wrk'
  url 'https://github.com/downloads/blangel/wrk/wrk.tar'
  sha1 '61f278d49fb44a09e7be884f99ef22c58d2b525c'
  version '1.0'

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

