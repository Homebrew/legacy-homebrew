require 'formula'

class Gmvault < Formula
  homepage 'http://gmvault.org'
  url 'https://bitbucket.org/gaubert/gmvault-official-download/downloads/gmvault-v1.7-beta-macosx-intel.tar.gz'
  sha1 'dc2f81096b943080f0ca93ec3ca112c6b64858a2'

  def install
    bin.install 'bin/gmvault'
    lib.install 'lib/gmv_runner.app'
  end

  def patches
    # The Gmvault binary distribution assumes that the gmv_runner.app bundle
    # is located in a `lib` directory relative to the `bin/gmvault` script.
    # Unfortunately, Homebrew won't install a `.app` bundle into `lib`; it
    # prefers bundles to remain in the cellar.  That's fine for us, but we
    # need to apply a small patch to `bin/gmvault` to help it find the
    # cellar'ed version of `lib/gmv_runner.app`.
    #
    # This patching process is further complicated in that we need to expand
    # the cellar location in the patch.  We perform that substitution here and
    # return a StringIO wrapper object so that the normal DATA-style patching
    # process can continue normally.
    if DATA.kind_of? IO
      patch = DATA.read.to_s.gsub('HOMEBREW_CELLAR', prefix)
      StringIO.new(patch)
    end
  end
end

__END__
diff --git a/bin/gmvault b/bin/gmvault
index 2cf1bd0..91a75f0 100755
--- a/bin/gmvault
+++ b/bin/gmvault
@@ -8,9 +8,7 @@
 #################################
 ## GMVAULT Distribution home directory
 #################################
-CDIR=`dirname "$0"`
-HERE=$(unset CDPATH; cd "$CDIR"; pwd)
-GMVAULT_HOME=$(unset CDPATH; cd "$HERE/.."; pwd)
+GMVAULT_HOME=HOMEBREW_CELLAR
 
 
 #################################
