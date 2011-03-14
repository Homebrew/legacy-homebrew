require 'formula'

class DrushMake < Formula
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.2.tar.gz'
  homepage 'http://drupal.org/project/drush_make'
  md5 '9dddd6567c4de66494bdadebfc3e2989'
end

class Drush < Formula
  url 'http://ftp.drupal.org/files/projects/drush-7.x-4.3.tar.gz'
  homepage 'http://drupal.org/project/drush'
  md5 '630005bef9521e3469991a79d2db423b'

  def install
    prefix.install Dir['*'] # No lib folder, so this is OK for now.
    bin.mkpath
    symlink prefix+'drush', bin+'drush'
    DrushMake.new.brew { (prefix+'commands/drush_make').install Dir['*'] }
  end
end
