class Npm < Formula
  homepage "https://www.npmjs.com/package/npm"
  url "https://registry.npmjs.org/npm/-/npm-2.3.0.tgz"
  sha1 "3588ec5c18fb5ac41e5721b0ea8ece3a85ab8b4b"

  option "without-completion", "npm bash completion will not be installed"

  depends_on :node

  # Patch node-gyp until github.com/TooTallNate/node-gyp/pull/564 is resolved
  patch :DATA

  def install
    ENV["NPM_CONFIG_LOGLEVEL"] = "verbose"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    if build.with? "completion"
        bash_completion.install \
        buildpath/"lib/utils/completion.sh" => "npm"
    end
  end

  def post_install
    # This is what makes everyone happy
    # make npm install everything to #{HOMEBREW_PREFIX}/lib/node_modules
    npmrc = lib/"node_modules/npm/npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats;
    s = ""
    s += <<-EOS.undent
      npm is prefixed to #{HOMEBREW_PREFIX} so global modules are installed to
        #{HOMEBREW_PREFIX}/lib/node_modules
      and then linked into
        #{HOMEBREW_PREFIX}/bin

    EOS

    s += <<-EOS.undent
      iojs currently requires a patched npm (i.e. not the npm installed by node).
      updating npm with npm currently will undo this patch.

    EOS

    s
  end

  test do
      assert (HOMEBREW_PREFIX/"bin/npm").exist?, "npm must exist"
      assert (HOMEBREW_PREFIX/"bin/npm").executable?, "npm must be executable"
      assert_equal which("npm"), opt_bin/"npm"
  end
end

__END__
diff --git a/node_modules/node-gyp/lib/install.js b/node_modules/node-gyp/lib/install.js
index 6f72e6a..ebc4e57 100644
--- a/node_modules/node-gyp/lib/install.js
+++ b/node_modules/node-gyp/lib/install.js
@@ -39,7 +39,7 @@ function install (gyp, argv, callback) {
     }
   }

-  var distUrl = gyp.opts['dist-url'] || gyp.opts.disturl || 'http://nodejs.org/dist'
+  var distUrl = gyp.opts['dist-url'] || gyp.opts.disturl || 'https://iojs.org/dist'


   // Determine which node dev files version we are installing
@@ -185,7 +185,7 @@ function install (gyp, argv, callback) {

       // now download the node tarball
       var tarPath = gyp.opts['tarball']
-      var tarballUrl = tarPath ? tarPath : distUrl + '/v' + version + '/node-v' + version + '.tar.gz'
+      var tarballUrl = tarPath ? tarPath : distUrl + '/v' + version + '/iojs-v' + version + '.tar.gz'
         , badDownload = false
         , extractCount = 0
         , gunzip = zlib.createGunzip()

