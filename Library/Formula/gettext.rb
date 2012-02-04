require 'formula'

class Gettext < Formula
  url 'http://ftpmirror.gnu.org/gettext/gettext-0.18.1.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gettext/gettext-0.18.1.1.tar.gz'
  md5 '3dd55b952826d2b32f51308f2f91aa89'
  homepage 'http://www.gnu.org/software/gettext/'

  keg_only "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

  def options
  [
    ['--with-examples', 'Keep example files.'],
    ['--universal', 'Build universal binaries.']
  ]
  end

  def patches
    # Patch to allow building with Xcode 4; safe for any compiler.
    p = {:p0 => ['https://trac.macports.org/export/79617/trunk/dports/devel/gettext/files/stpncpy.patch']}

    unless ARGV.include? '--with-examples'
      # Use a MacPorts patch to disable building examples at all,
      # rather than build them and remove them afterwards.
      p[:p0] << 'https://trac.macports.org/export/79183/trunk/dports/devel/gettext/files/patch-gettext-tools-Makefile.in'
    end

    return p
  end

  def patches
    { :p0 => DATA }
  end

  def install
    ENV.libxml2
    ENV.O3 # Issues with LLVM & O4 on Mac Pro 10.6

    ENV.universal_binary if ARGV.build_universal?

    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--without-included-gettext",
                          "--without-included-glib",
                          "--without-included-libcroco",
                          "--without-included-libxml",
                          "--without-emacs",
                          # Don't use VCS systems to create these archives
                          "--without-git",
                          "--without-cvs"
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make install"
  end
end

__END__
--- gettext-tools/misc/convert-archive.in	2010-06-06 14:49:57.000000000 +0200
+++ gettext-tools/misc/convert-archive.in.new	2011-05-17 22:07:25.000000000 +0200
@@ -305,6 +305,7 @@ case "$to" in
     git_dir=`pwd`/tmpgit$$
     mkdir "$git_dir" || func_fatal_error "mkdir failed"
     unset GIT_CONFIG
+    unset HOME
     (cd "$git_dir" && {
       git init -q
       git config user.name 'GNU Gettext Build'
