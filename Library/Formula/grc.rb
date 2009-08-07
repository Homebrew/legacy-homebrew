require 'brewkit'

######################################################################### cook
class Grc <Formula
  @homepage='http://korpus.juls.savba.sk/~garabik/software/grc.html'
  @url='http://korpus.juls.savba.sk/~garabik/software/grc/grc_1.3.tar.gz'
  @md5='a4814dcee965c3ff67681f6b59e6378c'

  def install
    if ARGV.include? '--profile'
      puts DATA.read
      exit
    end
    
    ohai "make"
    #TODO we should deprefixify since it's python and thus possible
    inreplace 'grc', '/etc', prefix+'etc'
    inreplace 'grc.1', '/etc', prefix+'etc'
    inreplace 'grcat', '/usr/local', prefix
    inreplace 'grcat.1', '/usr/local', prefix

    FileUtils.mkpath prefix
    Dir.chdir prefix do
      FileUtils.mkpath 'bin'
      FileUtils.mkpath 'share/grc'
      FileUtils.mkpath 'share/man/man1'
      FileUtils.mkpath 'etc'
    end

    `cp -fv grc grcat #{prefix}/bin`
    `cp -fv conf.* #{prefix}/share/grc`
    `cp -fv grc.conf #{prefix}/etc`
    `cp -fv grc.1 grcat.1 #{prefix}/share/man/man1`
  end

  def caveats
    <<-EOS
grc won't work as is. One option is to add some aliases to your ~/.profile
file. Homebrew can do that for you, just execute this command:

    brew install grc --profile >> ~/.profile
    EOS
  end
end

__END__
################################################################## >> Homebrew
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
################################################################## << Homebrew
