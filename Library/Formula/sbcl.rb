require 'formula'
require 'hardware'

class SbclBootstrapBinaries <Formula
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.30/sbcl-1.0.30-x86-darwin-binary.tar.bz2'
  md5 'c15bbff2e7a9083ecd50942edb74cc8c'
  version "1.0.30"
end


class Sbcl <Formula
  homepage 'http://www.sbcl.org/'
  head 'git://sbcl.boinkor.net/sbcl.git'

  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.45/sbcl-1.0.45-source.tar.bz2'
  md5 'b80e491b8e9228bbfa4fe679fd608697'
  version '1.0.45'

  skip_clean 'bin'
  skip_clean 'lib'

  def patches
    base = "http://svn.macports.org/repository/macports/trunk/dports/lang/sbcl/files"
    { :p0 => ["patch-base-target-features.diff",
              "patch-make-doc.diff",
              "patch-posix-tests.diff",
              "patch-use-mach-exception-handler.diff"].map { |file_name| "#{base}/#{file_name}" }
    }
  end

  def install
    build_directory = Dir.pwd
    SbclBootstrapBinaries.new.brew {
      # We only need the binaries for bootstrapping, so don't install
      # anything:

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
