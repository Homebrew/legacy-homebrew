require 'formula'

class Composer < Formula
  homepage 'http://getcomposer.org/'
  url 'http://getcomposer.org/download/1.0.0-alpha2/composer.phar'
  version '1.0.0-alpha2'
  md5 'b3d440b6b8a6413d9081440b49f92098'

  def install
    libexec.install "composer.phar"
    composer = libexec + "composer"
    composer.write("php #{libexec + 'composer.phar'} $*")
    chmod 0755, composer
    bin.install_symlink composer
  end

  def test
    system "composer"
  end
end
