require 'formula'

class Csync < Formula
  homepage 'http://www.csync.org/'
  url 'http://www.csync.org/files/csync-0.44.0.tar.gz'
  sha1 '43ac96260d580726006a4cf6878c0d3c536ff8cf'

  # Note: HEAD requires git:// protocol, https:// does not work.
  head 'git://git.csync.org/projects/csync.git'

  depends_on 'doxygen' => :build
  depends_on 'cmake' => :build
  depends_on 'check' => :build
  depends_on 'sqlite3'
  depends_on 'iniparser'
  depends_on 'argp-standalone'
  depends_on 'libssh' => :optional
  if ARGV.build_head?
    # Log4c and libsmbclient are optional in HEAD. See
    # http://git.csync.org/projects/csync.git/commit/?id=13f05db93484ad6100c1987d11e7a6d33bd5d754
    # http://git.csync.org/projects/csync.git/commit/?id=f064dbcde4e25cb4661be77a76be7279946be3d6
    depends_on 'log4c' => :optional
    depends_on 'samba' => :optional
  else
    depends_on 'log4c'
    depends_on 'samba'
  end

  def patches
    upstream = [
      # Upstream has seen much activity the past few months, and these
      # patches are selected commits that make compiling on OS X work.
      # cmake: Fix build on OSX.
      "http://git.csync.org/projects/csync.git/patch/?id=d0888ffba8f399da79708480a62cc2f3a914eb58",
      # time: Add csync_gettime() function.
      "http://git.csync.org/projects/csync.git/patch/?id=1d609e5985468980ce01ad8bf29de5dab494f706",
      # csync: Use csync_gettime().
      "http://git.csync.org/projects/csync.git/patch/?id=19abbc04ffa894505f92ea2e3ef80fd7fb046633",
      # time: Fix clock_gettime().
      "http://git.csync.org/projects/csync.git/patch/?id=63565b0f264c737e6b15490041412645d17809ac"
    ]
    local = [
      # This last patch is not in upstream, and removes an attempt to
      # set the non-existing O_NOATIME flag on OS X. Once this formula
      # also gets a HEAD build option, an issue will be opened upstream.
      DATA
    ]
    return ARGV.build_head? ? local : (upstream+local)
  end

  def install
    mkdir 'build' unless ARGV.build_head?
    cd 'build' do
      system "cmake", "..", *std_cmake_args
      # We need to run make csync first to make the "core",
      # or the build system will freak out and try to link
      # modules against core functions that aren't compiled
      # yet. We also have to patch "link.txt" for all module
      # targets. This should probably be reported upstream.
      system "make csync"
      Dir['modules/CMakeFiles/*/link.txt'].each do |f|
        inreplace f do |s|
          s.gsub! '-o', "../src/libcsync.dylib ../src/std/libcstdlib.a -o"
        end
      end
      # Now we can make and install.
      system "make all"
      system "make install"
    end
  end

  def test
    system "csync", "-V"
  end
end
__END__
--- a/src/csync_propagate.c 2012-07-01 13:12:12.000000000 +0200
+++ b/src/csync_propagate.c 2012-07-01 13:12:59.000000000 +0200
@@ -101,10 +101,6 @@
   /* Open the source file */
   ctx->replica = srep;
   flags = O_RDONLY|O_NOFOLLOW;
-  /* O_NOATIME can only be set by the owner of the file or the superuser */
-  if (st->uid == ctx->pwd.uid || ctx->pwd.euid == 0) {
-    flags |= O_NOATIME;
-  }
   sfp = csync_vio_open(ctx, suri, flags, 0);
   if (sfp == NULL) {
     if (errno == ENOMEM) {
