require 'formula'

class SbclBootstrapBinaries < Formula
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.30/sbcl-1.0.30-x86-darwin-binary.tar.bz2'
  md5 'c15bbff2e7a9083ecd50942edb74cc8c'
  version "1.0.30"
end

class Sbcl < Formula
  homepage 'http://www.sbcl.org/'
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.46/sbcl-1.0.46-source.tar.bz2'
  md5 '83f094aa36edce2d69214330890f05e5'
  head 'git://sbcl.boinkor.net/sbcl.git'

  skip_clean 'bin'
  skip_clean 'lib'

  def options
    [
      ["--without-threads",  "Build SBCL without support for native threads"],
      ["--with-ldb",  "Include low-level debugger in the build"],
      ["--with-internal-xref",  "Include XREF information for SBCL internals (increases core size by 5-6MB)"]
    ]
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

    build_directory = Dir.pwd
    SbclBootstrapBinaries.new.brew {
      # We only need the binaries for bootstrapping, so don't install anything:
      command = Dir.pwd + "/src/runtime/sbcl"
      core = Dir.pwd + "/output/sbcl.core"
      xc_cmdline = "#{command} --core #{core} --disable-debugger --no-userinit --no-sysinit"

      Dir.chdir(build_directory)
      system "./make.sh --prefix='#{prefix}' --xc-host='#{xc_cmdline}'"
    }

    ENV['INSTALL_ROOT'] = prefix
    system "sh install.sh"
  end
end
