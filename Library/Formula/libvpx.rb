require 'formula'

class Libvpx < Formula
  homepage 'http://www.webmproject.org/code/'
  url 'http://webm.googlecode.com/files/libvpx-v1.1.0.tar.bz2'
  sha1 '356af5f770c50cd021c60863203d8f30164f6021'

  depends_on 'yasm' => :build

  def options
    [
      ['--gcov', 'Enable code coverage'],
      ['--mem-tracker', 'Enable tracking memory usage'],
      ['--visualizer', 'Enable post processing visualizer']
    ]
  end

  # Fixes build error on ML, discussed in:
  # https://github.com/mxcl/homebrew/issues/12567
  # yasm: FATAL: unable to open include file `asm_enc_offsets.asm'.  Reported to:
  # https://groups.google.com/a/webmproject.org/group/webm-discuss/browse_thread/thread/39d1166feac1061c
  # Not yet in HEAD as of 20 JUN 2012.
  def patches; DATA; end

  def install
    args = ["--prefix=#{prefix}",
            "--enable-pic",
            "--disable-examples",
            "--disable-runtime-cpu-detect"]
    args << "--enable-gcov" if ARGV.include? "--gcov" and not ENV.compiler == :clang
    args << "--enable-mem-tracker" if ARGV.include? "--mem-tracker"
    args << "--enable-postproc-visualizer" if ARGV.include? "--visualizer"

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
