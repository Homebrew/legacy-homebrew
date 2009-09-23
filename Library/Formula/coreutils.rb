require 'brewkit'

COREUTILS_ALIASES=<<-EOS
brew_prefix=`brew --prefix`
alias base64="$brew_prefix/bin/gbase64"
alias basename="$brew_prefix/bin/gbasename"
alias cat="$brew_prefix/bin/gcat"
alias chcon="$brew_prefix/bin/gchcon"
alias chgrp="$brew_prefix/bin/gchgrp"
alias chmod="$brew_prefix/bin/gchmod"
alias chown="$brew_prefix/bin/gchown"
alias chroot="$brew_prefix/bin/gchroot"
alias cksum="$brew_prefix/bin/gcksum"
alias comm="$brew_prefix/bin/gcomm"
alias cp="$brew_prefix/bin/gcp"
alias csplit="$brew_prefix/bin/gcsplit"
alias cut="$brew_prefix/bin/gcut"
alias date="$brew_prefix/bin/gdate"
alias dd="$brew_prefix/bin/gdd"
alias df="$brew_prefix/bin/gdf"
alias dir="$brew_prefix/bin/gdir"
alias dircolors="$brew_prefix/bin/gdircolors"
alias dirname="$brew_prefix/bin/gdirname"
alias du="$brew_prefix/bin/gdu"
alias echo="$brew_prefix/bin/gecho"
alias env="$brew_prefix/bin/genv"
alias expand="$brew_prefix/bin/gexpand"
alias expr="$brew_prefix/bin/gexpr"
alias factor="$brew_prefix/bin/gfactor"
alias false="$brew_prefix/bin/gfalse"
alias fmt="$brew_prefix/bin/gfmt"
alias fold="$brew_prefix/bin/gfold"
alias groups="$brew_prefix/bin/ggroups"
alias head="$brew_prefix/bin/ghead"
alias hostid="$brew_prefix/bin/ghostid"
alias id="$brew_prefix/bin/gid"
alias install="$brew_prefix/bin/ginstall"
alias join="$brew_prefix/bin/gjoin"
alias kill="$brew_prefix/bin/gkill"
alias link="$brew_prefix/bin/glink"
alias ln="$brew_prefix/bin/gln"
alias logname="$brew_prefix/bin/glogname"
alias ls="$brew_prefix/bin/gls"
alias md5sum="$brew_prefix/bin/gmd5sum"
alias mkdir="$brew_prefix/bin/gmkdir"
alias mkfifo="$brew_prefix/bin/gmkfifo"
alias mknod="$brew_prefix/bin/gmknod"
alias mktemp="$brew_prefix/bin/gmktemp"
alias mv="$brew_prefix/bin/gmv"
alias nice="$brew_prefix/bin/gnice"
alias nl="$brew_prefix/bin/gnl"
alias nohup="$brew_prefix/bin/gnohup"
alias od="$brew_prefix/bin/god"
alias paste="$brew_prefix/bin/gpaste"
alias pathchk="$brew_prefix/bin/gpathchk"
alias pinky="$brew_prefix/bin/gpinky"
alias pr="$brew_prefix/bin/gpr"
alias printenv="$brew_prefix/bin/gprintenv"
alias printf="$brew_prefix/bin/gprintf"
alias ptx="$brew_prefix/bin/gptx"
alias pwd="$brew_prefix/bin/gpwd"
alias readlink="$brew_prefix/bin/greadlink"
alias rm="$brew_prefix/bin/grm"
alias rmdir="$brew_prefix/bin/grmdir"
alias runcon="$brew_prefix/bin/gruncon"
alias seq="$brew_prefix/bin/gseq"
alias sha1sum="$brew_prefix/bin/gsha1sum"
alias sha224sum="$brew_prefix/bin/gsha224sum"
alias sha256sum="$brew_prefix/bin/gsha256sum"
alias sha384sum="$brew_prefix/bin/gsha384sum"
alias sha512sum="$brew_prefix/bin/gsha512sum"
alias shred="$brew_prefix/bin/gshred"
alias shuf="$brew_prefix/bin/gshuf"
alias sleep="$brew_prefix/bin/gsleep"
alias sort="$brew_prefix/bin/gsort"
alias split="$brew_prefix/bin/gsplit"
alias stat="$brew_prefix/bin/gstat"
alias stty="$brew_prefix/bin/gstty"
alias sum="$brew_prefix/bin/gsum"
alias sync="$brew_prefix/bin/gsync"
alias tac="$brew_prefix/bin/gtac"
alias tail="$brew_prefix/bin/gtail"
alias tee="$brew_prefix/bin/gtee"
alias test="$brew_prefix/bin/gtest"
alias touch="$brew_prefix/bin/gtouch"
alias tr="$brew_prefix/bin/gtr"
alias true="$brew_prefix/bin/gtrue"
alias tsort="$brew_prefix/bin/gtsort"
alias tty="$brew_prefix/bin/gtty"
alias uname="$brew_prefix/bin/guname"
alias unexpand="$brew_prefix/bin/gunexpand"
alias uniq="$brew_prefix/bin/guniq"
alias unlink="$brew_prefix/bin/gunlink"
alias uptime="$brew_prefix/bin/guptime"
alias users="$brew_prefix/bin/gusers"
alias vdir="$brew_prefix/bin/gvdir"
alias wc="$brew_prefix/bin/gwc"
alias who="$brew_prefix/bin/gwho"
alias whoami="$brew_prefix/bin/gwhoami"
alias yes="$brew_prefix/bin/gyes"
alias '['="$brew_prefix/bin/g["
EOS

class Coreutils <Formula
  @url="http://ftp.gnu.org/gnu/coreutils/coreutils-7.5.tar.gz"
  @md5='775351410b7d6879767c3e4563354dc6'
  @homepage='http://www.gnu.org/software/coreutils'

  def install
    # Note this doesn't work right now as I have broken the install process
    # slightly so it errors out.
    if ARGV.include? '--aliases'
      puts COREUTILS_ALIASES
      exit 0
    end
    
    system "./configure --prefix=#{prefix} --program-prefix=g"
    system "make install"
  end

  def caveats; <<-EOS
All commands have been installed with the prefix 'g'. In order to use these
commands by default you can put some aliases in your bashrc. You can
accomplish this like so:

    brew install coreutils --aliases >> ~/.bashrc
    
Please note the manpages are still referenced with the g-prefix.
    EOS
  end
end
