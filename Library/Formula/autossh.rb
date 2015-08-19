class Autossh < Formula
  desc "Automatically restart SSH sessions and tunnels"
  homepage "http://www.harding.motd.ca/autossh/"
  url "http://www.harding.motd.ca/autossh/autossh-1.4e.tgz"
  mirror "http://ftp.de.debian.org/debian/pool/main/a/autossh/autossh_1.4e.orig.tar.gz"
  sha256 "9e8e10a59d7619176f4b986e256f776097a364d1be012781ea52e08d04679156"

  bottle do
    cellar :any
    sha256 "d6cc04e8d60e33d420153e44c96d9cddf1b863b1a9f87b93e046781845810e9d" => :yosemite
    sha256 "e041aabe60aa25c259170ffb5ee7a0debe57aa418f6f0552f430d2085516ed8c" => :mavericks
    sha256 "d5d0367913f4a3f98a00aee546c2b935004c0b54973d2cd20bd29ab6e5a7ea58" => :mountain_lion
  end

  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
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
