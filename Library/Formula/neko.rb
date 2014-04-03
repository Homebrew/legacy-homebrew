require 'formula'

class Neko < Formula
  homepage 'http://nekovm.org'

  # revision includes recent parameterized build targets for mac.  Use a :tag
  # on the next release
  url 'https://github.com/HaxeFoundation/neko.git', :revision => '6ab8f48a8dc62e4d917b599b3d8c8e10f764f839'

  version '2.0.0-6ab8f48'

  head 'https://github.com/HaxeFoundation/neko.git'

  bottle do
    cellar :any
    sha1 "d72b7af1c8ae7c58c613df9883f27466bfcca60f" => :mavericks
    sha1 "ad22cc3edca5ae05b663edf63d5cd496d3ad2b78" => :mountain_lion
    sha1 "77daff389d401d6764d1082ecc3448afbe27fccd" => :lion
  end

  depends_on 'bdw-gc'
  depends_on 'pcre'

  def patches
    DATA
  end

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    system "make", "os=osx", "LIB_PREFIX=#{HOMEBREW_PREFIX}", "INSTALL_FLAGS="

    include.install Dir['vm/neko*.h']
    neko = lib/'neko'
    neko.install Dir['bin/*']

    # Symlink into bin so libneko.dylib resolves correctly for custom prefix
    %w(neko nekoc nekoml nekotools).each do |file|
      bin.install_symlink neko/file
    end
    lib.install_symlink neko/"libneko.dylib"
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system "#{bin}/neko", "#{HOMEBREW_PREFIX}/lib/neko/test.n"
  end

  def caveats
    s = ''
    if HOMEBREW_PREFIX.to_s != '/usr/local'
      s << <<-EOS.undent
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
        EOS
    end
    s
  end
end

__END__
diff --git a/src/tools/install.neko b/src/tools/install.neko
index 1f1c14c..f8cf75e 100644
--- a/src/tools/install.neko
+++ b/src/tools/install.neko
@@ -158,7 +158,6 @@ search_includes = function(isap2) {
 		"/opt/local/include",
 		"/opt/local/include/mysql",
 		"/opt/local/include/mysql5/mysql",
-		"/Developer/Headers/FlatCarbon",
 		"/System/Library/Frameworks/Carbon.framework/Versions/A/Headers/",
 	);
 	var inc2;
