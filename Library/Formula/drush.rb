require 'formula'

class DrushMake < Formula
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.2.tar.gz'
  homepage 'http://drupal.org/project/drush_make'
  md5 '9dddd6567c4de66494bdadebfc3e2989'
end

class Drush < Formula
  url 'http://ftp.drupal.org/files/projects/drush-7.x-4.5.tar.gz'
  homepage 'http://drupal.org/project/drush'
  md5 'f6df0593c3d3c9a5a2d0bb382bf629ba'

  def install
    prefix.install Dir['*'] # No lib folder, so this is OK for now.
    bin.mkpath
    symlink prefix+'drush', bin+'drush'
    DrushMake.new.brew { (prefix+'commands/drush_make').install Dir['*'] }
  end
end
