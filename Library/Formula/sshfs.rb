require 'formula'

class Sshfs < Formula
  homepage 'http://osxfuse.github.io/'
  url 'https://github.com/osxfuse/sshfs/archive/osxfuse-sshfs-2.5.0.tar.gz'
  sha1 '34d81a2f6b4150bff5ee55978b98df50c0bd3152'

  option 'without-sshnodelay', "Don't compile NODELAY workaround for ssh"

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on :libtool

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'
  depends_on 'glib'
  depends_on :xcode

  def patches
    # Fixes issue https://github.com/osxfuse/sshfs/pull/4
    DATA
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--disable-sshnodelay" if build.without? 'sshnodelay'

    # Compatibility with Automake 1.13 and newer.
    inreplace 'configure.ac', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'
    inreplace 'configure.ac', 'AM_INIT_AUTOMAKE', 'AM_INIT_AUTOMAKE([subdir-objects])'

    system "autoreconf", "--force", "--install"
    system "./configure", *args
    system "make install"
  end
end

__END__
--- a/sshfs.c
+++ b/sshfs.c
@@ -313,6 +313,8 @@
	"ConnectTimeout",
	"ControlMaster",
	"ControlPath",
+	"ForwardAgent",
+	"ForwardX11",
	"GlobalKnownHostsFile",
	"GSSAPIAuthentication",
	"GSSAPIDelegateCredentials",
