# When trunk is 3.x, then 3.x is devel and 3.(x-1)
# is stable.
# https://code.google.com/p/v8/issues/detail?id=2545
# http://omahaproxy.appspot.com/

class V8 < Formula
  homepage "https://code.google.com/p/v8/"
  url 'https://github.com/v8/v8/archive/3.25.30.tar.gz'
  sha1 '207d0bb1dd5954fe691570e799b3c1e318741290'

  option 'with-readline', 'Use readline instead of libedit'

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  depends_on :python => :build # gyp doesn't run under 2.6 or lower
  depends_on 'readline' => :optional

  resource 'gyp' do
    url 'http://gyp.googlecode.com/svn/trunk', :revision => 1831
    version '1831'
  end

  # fix up libv8.dylib install_name
  # https://github.com/Homebrew/homebrew/issues/36571
  # https://code.google.com/p/v8/issues/detail?id=3871
  patch :DATA

  def install
    # Download gyp ourselves because running "make dependencies" pulls in ICU.
    (buildpath/'build/gyp').install resource('gyp')

    system "make", "native",
                   "library=shared",
                   "snapshot=on",
                   "console=readline",
                   "i18nsupport=off"

    prefix.install 'include'
    cd 'out/native' do
      lib.install Dir['lib*']
      bin.install 'd8', 'lineprocessor', 'process', 'shell' => 'v8'
      bin.install Dir['mksnapshot.*']
    end
  end
end
__END__
diff --git a/tools/gyp/v8.gyp b/tools/gyp/v8.gyp
index f7bdf52..f17b3cf 100644
--- a/tools/gyp/v8.gyp
+++ b/tools/gyp/v8.gyp
@@ -87,7 +87,8 @@
           'conditions': [
             ['OS=="mac"', {
               'xcode_settings': {
-                'OTHER_LDFLAGS': ['-dynamiclib', '-all_load']
+                'OTHER_LDFLAGS': ['-dynamiclib', '-all_load'],
+                'DYLIB_INSTALL_NAME_BASE': 'HOMEBREW_PREFIX/lib'
               },
             }],
             ['soname_version!=""', {
