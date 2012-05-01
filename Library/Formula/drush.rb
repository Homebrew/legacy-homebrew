require 'formula'

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  url 'http://ftp.drupal.org/files/projects/drush-7.x-5.1.tar.gz'
  md5 '329c3b9a658bd718e4212c2ac3a930cf'
  head 'git://git.drupal.org/project/drush.git'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'drush'
  end
end
