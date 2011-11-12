require 'formula'

class DrushMake < Formula
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.3.tar.gz'
  homepage 'http://drupal.org/project/drush_make'
  md5 'd6636db943d4f996474b09245060263c'
end

class Drush < Formula
  url 'http://ftp.drupal.org/files/projects/drush-7.x-4.5.tar.gz'
  head 'git://git.drupal.org/project/drush.git'
  homepage 'http://drupal.org/project/drush'
  md5 'f6df0593c3d3c9a5a2d0bb382bf629ba'

  def install
    prefix.install Dir['*'] # No lib folder, so this is OK for now.
    bin.mkpath
    symlink prefix+'drush', bin+'drush'
    DrushMake.new.brew { (prefix+'commands/drush_make').install Dir['*'] }
  end
end
