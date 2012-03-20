require 'formula'

class Libvpx < Formula
  homepage 'http://www.webmproject.org/code/'
  url 'http://webm.googlecode.com/files/libvpx-v1.0.0.tar.bz2'
  sha256 '07cedb0a19a44e6d81d75f52eea864f59ef10c6c725cb860431bec6641eafe21'

  depends_on 'yasm' => :build

  def options
    [
      ['--gcov', 'Enable code coverage'],
      ['--mem-tracker', 'Enable tracking memory usage'],
      ['--visualizer', 'Enable post processing visualizer']
    ]
  end

  def patches
    # see http://code.google.com/p/webm/issues/detail?id=396
    # Remove attempts by configure to specify a -isysroot path on Lion.
    # It's never needed on Lion because the correct default is set within
    # the compiler and because a CLT only user will never have an SDK path.
    # This stops a compile error for CLT-4.3 where configure malforms the
    # conftest command by using -isysroot without a path argument.  This
    # is what the command looks like when it's missing the arg:
    #       -isysroot -mmacosx-version-min=10.7
    DATA if MacOS.lion?
  end

  def install
    args = ["--prefix=#{prefix}",
            "--enable-pic",
            "--enable-vp8",
            "--disable-debug",
            "--disable-examples",
            "--disable-runtime-cpu-detect"]
    args << "--enable-gcov" if ARGV.include? "--gcov" and not ENV.compiler == :clang
    args << "--enable-mem-tracker" if ARGV.include? "--mem-tracker"
    args << "--enable-postproc-visualizer" if ARGV.include? "--visualizer"

    # see http://code.google.com/p/webm/issues/detail?id=401
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
--- a/build/make/configure.sh	2012-01-27 10:36:39.000000000 -0800
+++ b/build/make/configure.sh	2012-02-20 20:14:04.000000000 -0800
@@ -649,10 +649,6 @@
             add_ldflags "-mmacosx-version-min=10.6"
             ;;
         *-darwin11-*)
-            add_cflags  "-isysroot ${osx_sdk_dir}"
-            add_cflags  "-mmacosx-version-min=10.7"
-            add_ldflags "-isysroot ${osx_sdk_dir}"
-            add_ldflags "-mmacosx-version-min=10.7"
             ;;
     esac
 
