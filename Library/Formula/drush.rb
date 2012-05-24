require 'formula'

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  url 'http://ftp.drupal.org/files/projects/drush-7.x-5.2.tar.gz'
  md5 'eb18dc1640bcf7a9dc776dec5cd0d163'
  head 'git://git.drupal.org/project/drush.git'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'drush'
  end
end
