require 'formula'

class JoomlaCli < Formula
  homepage 'http://joomlacli.com'
  url 'https://bitbucket.org/juliopontes/joomla-cli/get/0.1.tar.gz'
  sha1 '51556da95a130aa0650786bc62e74f411c9f41bf'

  head 'git://bitbucket.org:juliopontes/joomla-cli.git'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'joomla'
  end
end
