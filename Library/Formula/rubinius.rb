require 'formula'

class Rubinius < Formula
  homepage 'http://rubini.us/'
  url 'http://releases.rubini.us/rubinius-2.0.0.tar.bz2'
  sha1 'b2b6c0c95eddcadd5b8db058a26c6975f1af26a4'
  head 'https://github.com/rubinius/rubinius.git'

  # Yes, rubinius actually needs a pre-existing ruby 2.0 install to build
  depends_on 'ruby' => :build

  env :std

  # Configure options like --libdir are broken; submitted upstream:
  # https://github.com/rubinius/rubinius/pull/2658
  def patches; DATA; end

  def install
    # Let Rubinius define its own flags; messing with these causes build breaks.
    ENV.remove_cc_etc

    # Unset RUBYLIB to configure Rubinius
    ENV.delete("RUBYLIB")

    # Set to stop Rubinius messing with our prefix.
    ENV["RELEASE"] = "1"

    system "bundle"
    system "./configure",
           "--skip-system", # download and use the prebuilt LLVM
           "--bindir", bin,
           "--prefix", prefix,
           "--includedir", "#{include}/rubinius",
           "--libdir", lib,
           "--mandir", man, # For completeness; no manpages exist yet.
           "--gemsdir", "#{lib}/rubinius/gems"

    ohai "config.rb", File.open('config.rb').to_a if ARGV.debug? or ARGV.verbose?

    system "rake", "install"

    # Remove conflicting command aliases
    bin.children.select(&:symlink?).each(&:unlink)
    # This conclicts with the Ruby command of the same name
    (bin/'testrb').unlink
  end

  test do
    assert_equal 'rbx', `"#{bin}/rbx" -e "puts RUBY_ENGINE"`.chomp
  end
end

__END__
diff --git a/configure b/configure
index 3e1a715..03c2ea7 100755
--- a/configure
+++ b/configure
@@ -384,7 +384,7 @@ class Configure
 
     o.on "-P", "--prefix", "PATH", "Install Rubinius in subdirectories of PATH" do |dir|
       warn_prefix dir
-      @prefixdir = dir
+      @prefixdir = dir.dup
     end
 
     o.on "-B", "--bindir", "PATH", "Install Rubinius executable in PATH" do |dir|
@@ -396,11 +396,11 @@ class Configure
     end
 
     o.on "-A", "--appdir", "PATH", "Install Ruby runtime and libraries in PATH" do |dir|
-      @appdir = dir
+      @appdir = dir.dup
     end
 
     o.on "-L", "--libdir", "PATH", "Install Rubinius shared library in PATH" do |dir|
-      @libdir = dir
+      @libdir = dir.dup
     end
 
     o.on "-M", "--mandir", "PATH", "Install man pages in PATH" do |dir|
