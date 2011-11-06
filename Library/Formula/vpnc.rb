require 'formula'

class Vpnc < Formula
  url 'http://www.unix-ag.uni-kl.de/~massar/vpnc/vpnc-0.5.3.tar.gz'
  homepage 'http://www.unix-ag.uni-kl.de/~massar/vpnc/'
  sha256 '46cea3bd02f207c62c7c6f2f22133382602baeda1dc320747809e94881414884'

  depends_on 'libgcrypt'
  depends_on 'libgpg-error'

  fails_with_llvm :build => 2334

  skip_clean 'etc'
  skip_clean 'var'

  def options
    [["--hybrid", "Use vpnc hybrid authentication."]]
  end

  # Patch from user @Imagesafari to enable compilation on Lion
  def patches
    DATA if MacOS.lion?
  end

  def install
    ENV.no_optimization
    ENV.deparallelize

    inreplace ["vpnc-script.in", "vpnc-disconnect"] do |s|
      s.gsub! "/var/run/vpnc", (var + 'run/vpnc')
    end

    inreplace "vpnc.8.template" do |s|
      s.gsub! "/etc/vpnc", (etc + 'vpnc')
    end

    inreplace "Makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "ETCDIR", (etc + 'vpnc')

      s.gsub! /^#OPENSSL/, "OPENSSL" if ARGV.include? "--hybrid"
    end

    inreplace "config.c" do |s|
      s.gsub! "/etc/vpnc", (etc + 'vpnc')
      s.gsub! "/var/run/vpnc", (var + 'run/vpnc')
    end

    system "make"
    (var + 'run/vpnc').mkpath
    system "make install"
  end

  def caveats; <<-EOS
    To use vpnc hybrid authentification:
      brew install vpnc --hybrid
    EOS
  end
end

__END__
--- vpnc-0.5.3/sysdep.h	2008-11-19 15:36:12.000000000 -0500
+++ vpnc-0.5.3.patched/sysdep.h	2011-07-14 12:49:18.000000000 -0400
@@ -109,6 +109,7 @@
 #define HAVE_FGETLN    1
 #define HAVE_UNSETENV  1
 #define HAVE_SETENV    1
+#define HAVE_GETLINE   1
 #endif
 
 /***************************************************************************/
