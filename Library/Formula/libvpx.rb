require 'formula'

class Libvpx < Formula
  homepage 'http://www.webmproject.org/code/'
  url 'http://webm.googlecode.com/files/libvpx-v1.1.0.tar.bz2'
  sha1 '356af5f770c50cd021c60863203d8f30164f6021'

  depends_on 'yasm' => :build

  option 'gcov', 'Enable code coverage'
  option 'mem-tracker', 'Enable tracking memory usage'
  option 'visualizer', 'Enable post processing visualizer'

  # Fixes build error on ML, discussed in:
  # https://github.com/mxcl/homebrew/issues/12567
  # yasm: FATAL: unable to open include file `asm_enc_offsets.asm'.
  # Reported to:
  # https://groups.google.com/a/webmproject.org/group/webm-discuss/browse_thread/thread/39d1166feac1061c
  # Not yet in HEAD as of 20 JUN 2012.
  # Add Mavericks as a comple target, upstream in:
  # http://git.chromium.org/gitweb/?p=webm/libvpx.git;a=commitdiff;h=fe4a52077f076fff4f3024373af21600afbc6df7
  def patches; DATA; end

  def install
    args = ["--prefix=#{prefix}",
            "--enable-pic",
            "--disable-examples",
            "--disable-runtime-cpu-detect"]
    args << "--enable-gcov" if build.include? "gcov" and not ENV.compiler == :clang
    args << "--enable-mem-tracker" if build.include? "mem-tracker"
    args << "--enable-postproc-visualizer" if build.include? "visualizer"

    # see http://code.google.com/p/webm/issues/detail?id=401
    # Configure misdetects 32-bit 10.6.
    # Determine if the computer runs Darwin 9, 10, or 11 using uname -r.
    osver = %x[uname -r | cut -d. -f1].chomp
    if MacOS.prefer_64_bit? then
      args << "--target=x86_64-darwin#{osver}-gcc"
    else
      args << "--target=x86-darwin#{osver}-gcc"
    end

    mkdir 'macbuild' do
      system "../configure", *args
      system "make install"
    end
  end
end

__END__
--- a/build/make/gen_asm_deps.sh	2012-05-08 16:14:00.000000000 -0700
+++ b/build/make/gen_asm_deps.sh	2012-06-19 20:26:54.000000000 -0700
@@ -42,7 +42,7 @@
 
 [ -n "$srcfile" ] || show_help
 sfx=${sfx:-asm}
-includes=$(LC_ALL=C egrep -i "include +\"?+[a-z0-9_/]+\.${sfx}" $srcfile |
+includes=$(LC_ALL=C egrep -i "include +\"+[a-z0-9_/]+\.${sfx}" $srcfile |
            perl -p -e "s;.*?([a-z0-9_/]+.${sfx}).*;\1;")
 #" restore editor state
 for inc in ${includes}; do

--- a/configure	2012-05-09 01:14:00.000000000 +0200
+++ b/configure	2013-07-19 10:10:02.000000000 +0200
@@ -111,6 +111,7 @@
 all_platforms="${all_platforms} x86-darwin10-gcc"
 all_platforms="${all_platforms} x86-darwin11-gcc"
 all_platforms="${all_platforms} x86-darwin12-gcc"
+all_platforms="${all_platforms} x86-darwin13-gcc"
 all_platforms="${all_platforms} x86-linux-gcc"
 all_platforms="${all_platforms} x86-linux-icc"
 all_platforms="${all_platforms} x86-os2-gcc"
@@ -123,6 +124,7 @@
 all_platforms="${all_platforms} x86_64-darwin10-gcc"
 all_platforms="${all_platforms} x86_64-darwin11-gcc"
 all_platforms="${all_platforms} x86_64-darwin12-gcc"
+all_platforms="${all_platforms} x86_64-darwin13-gcc"
 all_platforms="${all_platforms} x86_64-linux-gcc"
 all_platforms="${all_platforms} x86_64-linux-icc"
 all_platforms="${all_platforms} x86_64-solaris-gcc"
@@ -134,6 +136,7 @@
 all_platforms="${all_platforms} universal-darwin10-gcc"
 all_platforms="${all_platforms} universal-darwin11-gcc"
 all_platforms="${all_platforms} universal-darwin12-gcc"
+all_platforms="${all_platforms} universal-darwin13-gcc"
 all_platforms="${all_platforms} generic-gnu"

 # all_targets is a list of all targets that can be configured
