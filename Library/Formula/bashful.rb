require 'formula'

class Bashful <Formula
  url 'git://github.com/jmcantrell/bashful.git'
  version 'HEAD'
  homepage 'http://github.com/jmcantrell/bashful'

  depends_on 'coreutils'
  depends_on 'gawk'
  depends_on 'gnu-sed'
  depends_on 'gnu-tar'

  def patches
    DATA
  end

  def install
    ENV['PREFIX'] = prefix
    system "bash setup.sh install"
  end
end

# This patch makes sure GNU tools are used on OSX.

__END__
diff --git a/bin/bashful-core b/bin/bashful-core
index e4d5c9e..fa20bf6 100755
--- a/bin/bashful-core
+++ b/bin/bashful-core
@@ -15,6 +15,102 @@ fi
 # Nothing here yet. If this was installed using homebrew, then you will see
 # some aliases below. This is so that users on OS X will be using GNU utils.
 
-# __ALIASES__
+alias base64='gbase64'
+alias basename='gbasename'
+alias cat='gcat'
+alias chcon='gchcon'
+alias chgrp='gchgrp'
+alias chmod='gchmod'
+alias chown='gchown'
+alias chroot='gchroot'
+alias cksum='gcksum'
+alias comm='gcomm'
+alias cp='gcp'
+alias csplit='gcsplit'
+alias cut='gcut'
+alias date='gdate'
+alias dd='gdd'
+alias df='gdf'
+alias dir='gdir'
+alias dircolors='gdircolors'
+alias dirname='gdirname'
+alias du='gdu'
+alias echo='gecho'
+alias env='genv'
+alias expand='gexpand'
+alias expr='gexpr'
+alias factor='gfactor'
+alias false='gfalse'
+alias fmt='gfmt'
+alias fold='gfold'
+alias groups='ggroups'
+alias head='ghead'
+alias hostid='ghostid'
+alias id='gid'
+alias install='ginstall'
+alias join='gjoin'
+alias kill='gkill'
+alias link='glink'
+alias ln='gln'
+alias logname='glogname'
+alias ls='gls'
+alias md5sum='gmd5sum'
+alias mkdir='gmkdir'
+alias mkfifo='gmkfifo'
+alias mknod='gmknod'
+alias mktemp='gmktemp'
+alias mv='gmv'
+alias nice='gnice'
+alias nl='gnl'
+alias nohup='gnohup'
+alias nproc='gnproc'
+alias od='god'
+alias paste='gpaste'
+alias pathchk='gpathchk'
+alias pinky='gpinky'
+alias pr='gpr'
+alias printenv='gprintenv'
+alias printf='gprintf'
+alias readlink='greadlink'
+alias rm='grm'
+alias rmdir='grmdir'
+alias runcon='gruncon'
+alias seq='gseq'
+alias sha1sum='gsha1sum'
+alias sha224sum='gsha224sum'
+alias sha256sum='gsha256sum'
+alias sha384sum='gsha384sum'
+alias sha512sum='gsha512sum'
+alias shred='gshred'
+alias shuf='gshuf'
+alias sleep='gsleep'
+alias sort='gsort'
+alias split='gsplit'
+alias stat='gstat'
+alias stty='gstty'
+alias sum='gsum'
+alias sync='gsync'
+alias tac='gtac'
+alias tail='gtail'
+alias tee='gtee'
+alias test='gtest'
+alias timeout='gtimeout'
+alias touch='gtouch'
+alias tr='gtr'
+alias true='gtrue'
+alias truncate='gtruncate'
+alias tsort='gtsort'
+alias tty='gtty'
+alias uname='guname'
+alias unexpand='gunexpand'
+alias uniq='guniq'
+alias unlink='gunlink'
+alias uptime='guptime'
+alias users='gusers'
+alias vdir='gvdir'
+alias wc='gwc'
+alias who='gwho'
+alias whoami='gwhoami'
+alias yes='gyes'
 
 BASHFUL_CORE_LOADED=1
