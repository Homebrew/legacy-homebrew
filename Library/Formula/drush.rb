require 'formula'

class DrushMake < Formula
  homepage 'http://drupal.org/project/drush_make'
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.3.tar.gz'
  md5 'd6636db943d4f996474b09245060263c'
end

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  url 'http://ftp.drupal.org/files/projects/drush-7.x-4.5.tar.gz'
  md5 'f6df0593c3d3c9a5a2d0bb382bf629ba'
  head 'git://git.drupal.org/project/drush.git'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'drush'
    DrushMake.new.brew { (libexec+'commands/drush_make').install Dir['*'] }
  end
end
