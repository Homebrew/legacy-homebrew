require 'formula'

class SbclBootstrapBinaries < Formula
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.55/sbcl-1.0.55-x86-darwin-binary.tar.bz2'
  md5 '941351112392a77dd62bdcb9fb62e4e4'
  version "1.0.55"
end

class Sbcl < Formula
  homepage 'http://www.sbcl.org/'
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.58/sbcl-1.0.58-source.tar.bz2'
  md5 '341952949dc90af6f83a89f685da5dde'
  head 'git://sbcl.git.sourceforge.net/gitroot/sbcl/sbcl.git'

  bottle do
    url 'https://downloads.sf.net/project/machomebrew/Bottles/sbcl-1.0.55-bottle.tar.gz'
    sha1 '3c13225c8fe3eabf54e9d368e6b74318a5546430'
  end

  fails_with :llvm do
    build 2334
    cause "Compilation fails with LLVM."
  end

  skip_clean 'bin'
  skip_clean 'lib'

  def options
    [
      ["--without-threads",  "Build SBCL without support for native threads"],
      ["--with-ldb",  "Include low-level debugger in the build"],
      ["--with-internal-xref",  "Include XREF information for SBCL internals (increases core size by 5-6MB)"],
      ["--32-bit", "Build 32-bit only."]
    ]
  end

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
    features << ":sb-thread" unless ARGV.include? "--without-threads"
    features << ":sb-ldb" if ARGV.include? "--with-ldb"
    features << ":sb-xref-for-internals" if ARGV.include? "--with-internal-xref"

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
      value =~ /[\x80-\xff]/
    end

    SbclBootstrapBinaries.new.brew do
      # We only need the binaries for bootstrapping, so don't install anything:
      command = Dir.pwd + "/src/runtime/sbcl"
      core = Dir.pwd + "/output/sbcl.core"
      xc_cmdline = "#{command} --core #{core} --disable-debugger --no-userinit --no-sysinit"

      cd buildpath do
        ENV['SBCL_ARCH'] = 'x86' if ARGV.build_32_bit?
        system "./make.sh", "--prefix=#{prefix}", "--xc-host=#{xc_cmdline}"
      end
    end

    ENV['INSTALL_ROOT'] = prefix
    system "sh install.sh"
  end
end
