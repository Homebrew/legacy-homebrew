require 'formula'

class Sbcl <Formula
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.29/sbcl-1.0.29-x86-darwin-binary-r2.tar.bz2'
  version '1.0.29'
  homepage 'http://www.sbcl.org/'
  md5 '6e6b027a5fd05ef0c8faee30d89ffe54'

  skip_clean 'bin'

  def install
    ENV['INSTALL_ROOT'] = prefix
    system "sh install.sh"
  end
end
