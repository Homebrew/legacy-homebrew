require 'formula'

class DrushMake < Formula
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.2.tar.gz'
  homepage 'http://drupal.org/project/drush_make'
  md5 '9dddd6567c4de66494bdadebfc3e2989'
end

class Drush < Formula
  url 'http://ftp.drupal.org/files/projects/drush-7.x-4.5-rc1.tar.gz'
  homepage 'http://drupal.org/project/drush'
  md5 'dfec146b72352a69f81e18b5d087806c'

  def install
    prefix.install Dir['*'] # No lib folder, so this is OK for now.
    bin.mkpath
    symlink prefix+'drush', bin+'drush'
    DrushMake.new.brew { (prefix+'commands/drush_make').install Dir['*'] }
  end
end
