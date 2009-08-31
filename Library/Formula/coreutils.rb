require 'brewkit'

COREUTILS_ALIASES=<<-EOS
alias base64="/usr/local/bin/gbase64"
alias basename="/usr/local/bin/gbasename"
alias cat="/usr/local/bin/gcat"
alias chcon="/usr/local/bin/gchcon"
alias chgrp="/usr/local/bin/gchgrp"
alias chmod="/usr/local/bin/gchmod"
alias chown="/usr/local/bin/gchown"
alias chroot="/usr/local/bin/gchroot"
alias cksum="/usr/local/bin/gcksum"
alias comm="/usr/local/bin/gcomm"
alias cp="/usr/local/bin/gcp"
alias csplit="/usr/local/bin/gcsplit"
alias cut="/usr/local/bin/gcut"
alias date="/usr/local/bin/gdate"
alias dd="/usr/local/bin/gdd"
alias df="/usr/local/bin/gdf"
alias dir="/usr/local/bin/gdir"
alias dircolors="/usr/local/bin/gdircolors"
alias dirname="/usr/local/bin/gdirname"
alias du="/usr/local/bin/gdu"
alias echo="/usr/local/bin/gecho"
alias env="/usr/local/bin/genv"
alias expand="/usr/local/bin/gexpand"
alias expr="/usr/local/bin/gexpr"
alias factor="/usr/local/bin/gfactor"
alias false="/usr/local/bin/gfalse"
alias fmt="/usr/local/bin/gfmt"
alias fold="/usr/local/bin/gfold"
alias groups="/usr/local/bin/ggroups"
alias head="/usr/local/bin/ghead"
alias hostid="/usr/local/bin/ghostid"
alias id="/usr/local/bin/gid"
alias install="/usr/local/bin/ginstall"
alias join="/usr/local/bin/gjoin"
alias kill="/usr/local/bin/gkill"
alias link="/usr/local/bin/glink"
alias ln="/usr/local/bin/gln"
alias logname="/usr/local/bin/glogname"
alias ls="/usr/local/bin/gls"
alias md5sum="/usr/local/bin/gmd5sum"
alias mkdir="/usr/local/bin/gmkdir"
alias mkfifo="/usr/local/bin/gmkfifo"
alias mknod="/usr/local/bin/gmknod"
alias mktemp="/usr/local/bin/gmktemp"
alias mv="/usr/local/bin/gmv"
alias nice="/usr/local/bin/gnice"
alias nl="/usr/local/bin/gnl"
alias nohup="/usr/local/bin/gnohup"
alias od="/usr/local/bin/god"
alias paste="/usr/local/bin/gpaste"
alias pathchk="/usr/local/bin/gpathchk"
alias pinky="/usr/local/bin/gpinky"
alias pr="/usr/local/bin/gpr"
alias printenv="/usr/local/bin/gprintenv"
alias printf="/usr/local/bin/gprintf"
alias ptx="/usr/local/bin/gptx"
alias pwd="/usr/local/bin/gpwd"
alias readlink="/usr/local/bin/greadlink"
alias rm="/usr/local/bin/grm"
alias rmdir="/usr/local/bin/grmdir"
alias runcon="/usr/local/bin/gruncon"
alias seq="/usr/local/bin/gseq"
alias sha1sum="/usr/local/bin/gsha1sum"
alias sha224sum="/usr/local/bin/gsha224sum"
alias sha256sum="/usr/local/bin/gsha256sum"
alias sha384sum="/usr/local/bin/gsha384sum"
alias sha512sum="/usr/local/bin/gsha512sum"
alias shred="/usr/local/bin/gshred"
alias shuf="/usr/local/bin/gshuf"
alias sleep="/usr/local/bin/gsleep"
alias sort="/usr/local/bin/gsort"
alias split="/usr/local/bin/gsplit"
alias stat="/usr/local/bin/gstat"
alias stty="/usr/local/bin/gstty"
alias sum="/usr/local/bin/gsum"
alias sync="/usr/local/bin/gsync"
alias tac="/usr/local/bin/gtac"
alias tail="/usr/local/bin/gtail"
alias tee="/usr/local/bin/gtee"
alias test="/usr/local/bin/gtest"
alias touch="/usr/local/bin/gtouch"
alias tr="/usr/local/bin/gtr"
alias true="/usr/local/bin/gtrue"
alias tsort="/usr/local/bin/gtsort"
alias tty="/usr/local/bin/gtty"
alias uname="/usr/local/bin/guname"
alias unexpand="/usr/local/bin/gunexpand"
alias uniq="/usr/local/bin/guniq"
alias unlink="/usr/local/bin/gunlink"
alias uptime="/usr/local/bin/guptime"
alias users="/usr/local/bin/gusers"
alias vdir="/usr/local/bin/gvdir"
alias wc="/usr/local/bin/gwc"
alias who="/usr/local/bin/gwho"
alias whoami="/usr/local/bin/gwhoami"
alias yes="/usr/local/bin/gyes"
alias '['="/usr/local/bin/g["
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