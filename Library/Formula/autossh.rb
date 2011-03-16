require 'formula'

class Autossh < Formula
  url 'http://www.harding.motd.ca/autossh/autossh-1.4b.tgz'
  homepage 'http://www.harding.motd.ca/autossh/'
  md5 '8f9aa006f6f69e912d3c2f504622d6f7'

  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
    bin.install 'rscreen'
  end
end


__END__
diff --git a/rscreen b/rscreen
index f0bbced..ce232c3 100755
--- a/rscreen
+++ b/rscreen
@@ -23,4 +23,4 @@ fi
 #AUTOSSH_PATH=/usr/local/bin/ssh
 export AUTOSSH_POLL AUTOSSH_LOGFILE AUTOSSH_DEBUG AUTOSSH_PATH AUTOSSH_GATETIME AUTOSSH_PORT
 
-autossh -M 20004 -t $1 "screen -e^Zz -D -R"
+autossh -M 20004 -t $1 "screen -D -R"
