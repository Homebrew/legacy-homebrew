class Autossh < Formula
  desc "Automatically restart SSH sessions and tunnels"
  homepage "http://www.harding.motd.ca/autossh/"
  url "http://www.harding.motd.ca/autossh/autossh-1.4e.tgz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/a/autossh/autossh_1.4e.orig.tar.gz"
  sha256 "9e8e10a59d7619176f4b986e256f776097a364d1be012781ea52e08d04679156"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "9eb45f4246ed8db8cf639772bb252cedca944b480e7b8bedeeff4e96635a7a97" => :el_capitan
    sha256 "5926ad9cc35738f1fc5eebc8dd68770a0cc62f8a1c5344cc01547c246821e7c1" => :yosemite
    sha256 "4c86bc07f832f9ffeffc6542ecd102925fdebb363cfc354903cba2e9faa7900c" => :mavericks
  end

  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    bin.install "rscreen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autossh -V")
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
