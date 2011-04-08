require 'formula'

class Grc < Formula
  homepage 'http://korpus.juls.savba.sk/~garabik/software/grc.html'
  url 'http://korpus.juls.savba.sk/~garabik/software/grc/grc_1.3.tar.gz'
  md5 'a4814dcee965c3ff67681f6b59e6378c'

  def install
    #TODO we should deprefixify since it's python and thus possible
    inreplace ['grc', 'grc.1'], '/etc', etc
    inreplace ['grcat', 'grcat.1'], '/usr/local', prefix

    etc.install 'grc.conf'
    bin.install %w[grc grcat]
    (share+'grc').install Dir['conf.*']
    man1.install %w[grc.1 grcat.1]

    (prefix+'etc/grc.bashrc').write rc_script
  end

  def rc_script; <<-EOS.undent
    GRC=`which grc`
    if [ "$TERM" != dumb ] && [ -n GRC ]
    then
        alias colourify="$GRC -es --colour=auto"
        alias configure='colourify ./configure'
        alias diff='colourify diff'
        alias make='colourify make'
        alias gcc='colourify gcc'
        alias g++='colourify g++'
        alias as='colourify as'
        alias gas='colourify gas'
        alias ld='colourify ld'
        alias netstat='colourify netstat'
        alias ping='colourify ping'
        alias traceroute='colourify /usr/sbin/traceroute'
    fi
    EOS
  end

  def caveats; <<-EOS.undent
    New shell sessions will start using GRC after you run the following command:
      echo 'source "`brew --prefix grc`/etc/grc.bashrc"' >> ~/.bashrc
    EOS
  end
end
