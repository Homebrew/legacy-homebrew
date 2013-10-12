require 'formula'

class Libvpx < Formula
  homepage 'http://www.webmproject.org/code/'
  url 'http://webm.googlecode.com/files/libvpx-v1.2.0.tar.bz2'
  sha1 'e968e090898cc3a0aef3e3d9c3717e2d696010c8'

  depends_on 'yasm' => :build

  option 'gcov', 'Enable code coverage'
  option 'mem-tracker', 'Enable tracking memory usage'
  option 'visualizer', 'Enable post processing visualizer'

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
    args << "--extra-cflags=-DGTEST_USE_OWN_TR1_TUPLE=1" # Mavericks uses libc++ which doesn't supply <TR1/tuple>

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
