require "formula"

class Autossh < Formula
  homepage "http://www.harding.motd.ca/autossh/"
  url "http://www.harding.motd.ca/autossh/autossh-1.4d.tgz"
  mirror "http://ftp.de.debian.org/debian/pool/main/a/autossh/autossh_1.4d.orig.tar.gz"
  sha1 "27da23c357f8d263aba6ecf3e8792a3552d90e50"

  bottle do
    cellar :any
    sha1 "4233a7ced33f61621bbfe993a38b1f341b50fa37" => :yosemite
    sha1 "5438d61bc2751a0f7225882199f9e25cdc61863f" => :mavericks
    sha1 "3dc121773b268bb858d65e2824be58dee8495289" => :mountain_lion
  end

  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
    bin.install "rscreen"
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
