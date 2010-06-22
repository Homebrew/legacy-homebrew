require 'formula'
require 'hardware'

class Sbcl <Formula
  if MACOS_VERSION >= 10.6 and Hardware.is_64_bit?
    url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.29/sbcl-1.0.29-x86_64-darwin-binary-r2.tar.bz2'
    md5 '47c99c60ec44e57070807c0890ba1c90'
  else
    url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.29/sbcl-1.0.29-x86-darwin-binary-r2.tar.bz2'
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.29/sbcl-1.0.29-x86-darwin-binary-r2.tar.bz2'
    md5 '6e6b027a5fd05ef0c8faee30d89ffe54'
  end
  version '1.0.29'
  homepage 'http://www.sbcl.org/'

  skip_clean 'bin'
  skip_clean 'lib'

  def install
    ENV['INSTALL_ROOT'] = prefix
    system "sh install.sh"
  end
end
