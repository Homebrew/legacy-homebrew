require 'formula'
require 'hardware'

class SbclBootstrapBinaries <Formula
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.29/sbcl-1.0.29-x86-darwin-binary-r2.tar.bz2'
  md5 '6e6b027a5fd05ef0c8faee30d89ffe54'
  version "1.0.29"
end


class Sbcl <Formula
  homepage 'http://www.sbcl.org/'
  head 'git://sbcl.boinkor.net/sbcl.git'

  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.44/sbcl-1.0.44-source.tar.bz2'
  md5 'f34a3995db6e12439996096fd437f878'
  version '1.0.44'

  skip_clean 'bin'
  skip_clean 'lib'

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
