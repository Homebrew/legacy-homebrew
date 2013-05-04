require 'formula'

class SbclBootstrapBinaries < Formula
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.1.0/sbcl-1.1.0-x86-64-darwin-binary.tar.bz2'
  sha1 'ed2069e124027c43926728c48d604efbb4e33950'
  version "1.1.0"
end

class Sbcl < Formula
  homepage 'http://www.sbcl.org/'
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.1.4/sbcl-1.1.4-source.tar.bz2'
  sha1 '57c1055821e4ad1c9c1b2b75fa972c5ae7ca86d0'

  head 'git://sbcl.git.sourceforge.net/gitroot/sbcl/sbcl.git'

  bottle do
    sha1 'f3a56af6651fad229616ce0ad182fa4829b1c0f2' => :mountain_lion
    sha1 'cec671e27e8a23ff8b9c6f8d15549a7cfc688bcb' => :lion
    sha1 'f148420a1d44f0a8e5fe56ac57639fe6421a22c3' => :snow_leopard
  end

  fails_with :llvm do
    build 2334
    cause "Compilation fails with LLVM."
  end

  option "32-bit"
  option "without-threads", "Build SBCL without support for native threads"
  option "with-ldb", "Include low-level debugger in the build"
  option "with-internal-xref", "Include XREF information for SBCL internals (increases core size by 5-6MB)"

  def patches
    { :p0 => [
        "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-base-target-features.diff",
        "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-make-doc.diff",
        "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-posix-tests.diff",
        "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-use-mach-exception-handler.diff"
    ]}
  end

  def write_features
    features = []
    features << ":sb-thread" unless build.include? "without-threads"
    features << ":sb-ldb" if build.include? "with-ldb"
    features << ":sb-xref-for-internals" if build.include? "with-internal-xref"

    File.open("customize-target-features.lisp", "w") do |file|
      file.puts "(lambda (list)"
      features.each do |f|
        file.puts "  (pushnew #{f} list)"
      end
      file.puts "  list)"
    end
  end

  def install
    write_features

    # Remove non-ASCII values from environment as they cause build failures
    # More information: http://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |key, value|
      value =~ /[\x80-\xff]/n
    end

    SbclBootstrapBinaries.new.brew do
      # We only need the binaries for bootstrapping, so don't install anything:
      command = Dir.pwd + "/src/runtime/sbcl"
      core = Dir.pwd + "/output/sbcl.core"
      xc_cmdline = "#{command} --core #{core} --disable-debugger --no-userinit --no-sysinit"

      cd buildpath do
        ENV['SBCL_ARCH'] = 'x86' if build.build_32_bit?
        system "./make.sh", "--prefix=#{prefix}", "--xc-host=#{xc_cmdline}"
      end
    end

    ENV['INSTALL_ROOT'] = prefix
    system "sh install.sh"
  end

  def caveats; <<-EOS.undent
    If you are upgrading sbcl and you have installed maxima,
    you have to reinstall maxima:

      brew rm maxima && brew install maxima
    EOS
  end
end
