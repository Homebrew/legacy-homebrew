require 'formula'

class Sshfs < Formula
  homepage 'http://osxfuse.github.io/'
  url 'https://github.com/osxfuse/sshfs/archive/osxfuse-sshfs-2.5.0.tar.gz'
  sha1 '34d81a2f6b4150bff5ee55978b98df50c0bd3152'

  bottle do
    cellar :any
    sha1 "af9fbf03eff59354c0d4071de23ad44f68d986bd" => :mavericks
    sha1 "7fa3b69a4f3f4cd06a32c11df13db57f21437c88" => :mountain_lion
    sha1 "8828686ca5c28061825fe059d7d6b9afae5972e9" => :lion
  end

  option 'without-sshnodelay', "Don't compile NODELAY workaround for ssh"

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on :libtool

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'
  depends_on 'glib'
  depends_on :xcode

  # Fixes issue https://github.com/osxfuse/sshfs/pull/4
  patch :DATA

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
