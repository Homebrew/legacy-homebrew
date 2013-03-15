require 'formula'

class SshCopyId < Formula
  homepage 'http://openssh.org/'
  url 'http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.0p1.tar.gz'
  mirror 'http://ftp.spline.de/pub/OpenBSD/OpenSSH/portable/openssh-6.0p1.tar.gz'
  version '6.0p1'
  sha1 'f691e53ef83417031a2854b8b1b661c9c08e4422'

  def install
    bin.install 'contrib/ssh-copy-id'
    man1.install 'contrib/ssh-copy-id.1'
  end

  def patches
    # /bin/sh on the host (fixes an issue with fish shell)
    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=390344#10
    DATA
  end
end

__END__
diff --git a/contrib/ssh-copy-id b/contrib/ssh-copy-id
index 9451ace..2e4e9ac 100644
--- a/contrib/ssh-copy-id
+++ b/contrib/ssh-copy-id
@@ -41,7 +41,7 @@ fi
 # strip any trailing colon
 host=`echo $1 | sed 's/:$//'`

-{ eval "$GET_ID" ; } | ssh $host "umask 077; test -d ~/.ssh || mkdir ~/.ssh ; cat >> ~/.ssh/authorized_keys" || exit 1
+{ eval "$GET_ID" ; } | ssh $host "sh -c 'umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys'" || exit 1

 cat <<EOF
 Now try logging into the machine, with "ssh '$host'", and check in:
