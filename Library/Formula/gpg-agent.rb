class GpgAgent < Formula
  homepage "https://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.27.tar.bz2"
  mirror "ftp://ftp.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.27.tar.bz2"
  sha1 "d065be185f5bac8ea07b210ab7756e79b83b63d4"

  bottle do
    sha256 "1e516200de1786beeb5de9dbc14e18db0794914a8d931ecc7af0e6c37a4545ed" => :yosemite
    sha256 "5e2619d61dbe587c0a457937887a8555ed87b6e52abe17ef55af454a5ce5ca72" => :mavericks
    sha256 "3897518fdb9d4b9a159a9e29d64fef1a515ebac83c3b5fce1a45ab3bb5e534dc" => :mountain_lion
  end

  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "pth"
  depends_on "pinentry"

  # Adjust package name to fit our scheme of packaging both
  # gnupg 1.x and 2.x, and gpg-agent separately
  patch :DATA

  def install
    # don't use Clang's internal stdint.h
    ENV["gl_cv_absolute_stdint_h"] = "#{MacOS.sdk_path}/usr/include/stdint.h"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-agent-only",
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry",
                          "--with-scdaemon-pgm=#{Formula["gnupg2"].opt_libexec}/scdaemon"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
      Remember to set a graphical pinentry program (such as pinentry-mac) in your
      ~/.gnupg/gpg-agent.conf if you configure launchd to start gpg-agent at login.
    EOS
  end

  test do
    system "#{bin}/gpg-agent", "--help"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>/bin/sh</string>
            <string>-c</string>
            <string>#{opt_prefix}/bin/gpg-agent -c --daemon | /bin/launchctl</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
        <key>ServiceDescription</key>
        <string>Run gpg-agent at login</string>
    </dict>
    </plist>
    EOS
  end
end

__END__
diff --git a/configure b/configure
index c022805..96ea7ed 100755
--- a/configure
+++ b/configure
@@ -578,8 +578,8 @@ MFLAGS=
 MAKEFLAGS=

 # Identity of this package.
-PACKAGE_NAME='gnupg'
-PACKAGE_TARNAME='gnupg'
+PACKAGE_NAME='gpg-agent'
+PACKAGE_TARNAME='gpg-agent'
 PACKAGE_VERSION='2.0.27'
 PACKAGE_STRING='gnupg 2.0.27'
 PACKAGE_BUGREPORT='http://bugs.gnupg.org'
