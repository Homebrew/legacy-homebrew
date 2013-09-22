require 'formula'

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  head 'https://github.com/drush-ops/drush.git'
  url 'https://github.com/drush-ops/drush/archive/6.0.0.tar.gz'
  sha1 'de8b4065f179f6ddfd9c8911c2f818f81ab1f4a4'

  def install
    prefix.install_metafiles
    libexec.install Dir['*'] -['drush.bat']
    bin.install_symlink libexec/'drush'
    bash_completion.install libexec/'drush.complete.sh' => 'drush'
  end
end
