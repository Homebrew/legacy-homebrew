require 'formula'

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  url 'http://ftp.drupal.org/files/projects/drush-7.x-5.6.tar.gz'
  sha1 '85eb48940833b3acd57927f94c6fd2b35e521c31'

  head 'git://git.drupal.org/project/drush.git'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'drush'
  end
end
