$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'
require 'fileutils'

def profile_string
  <<-sput
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
  sput
end

######################################################################### ARGV
case ARGV[0]
  when '--profile' then
    puts profile_string
    exit 0
end

######################################################################### cook
homepage='http://korpus.juls.savba.sk/~garabik/software/grc.html'
url='http://korpus.juls.savba.sk/~garabik/software/grc/grc_1.1.tar.gz'
md5='eeb612aba2fff14cbaf1f3bec7e1eb60'

Formula.new(url, md5).brew do |prefix|
  ohai "make"  
  #TODO we should deprefixify since it's python and thus possible
  inreplace 'grc', '/etc', prefix+'/etc'
  inreplace 'grc.1', '/etc', prefix+'/etc'
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

  <<-nruter
grc won't work as is. One option is to add some aliases to your ~/.profile 
file. Homebrew can do that for you, just execute this command:

    ruby #{$0} --profile >> ~/.profile

nruter
end
