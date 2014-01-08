require 'formula'

class Drush < Formula
  homepage 'https://github.com/drush-ops/drush'
  head 'https://github.com/drush-ops/drush.git'
  url 'https://github.com/drush-ops/drush/archive/6.2.0.tar.gz'
  sha1 '7e13d5264f362ec09efbe8218e13dcd646ba75b3'

  def install
    prefix.install_metafiles
    libexec.install Dir['*'] -['drush.bat']
    bin.install_symlink libexec/'drush'
    bash_completion.install libexec/'drush.complete.sh' => 'drush'
  end
end
