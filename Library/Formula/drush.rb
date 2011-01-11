require 'formula'

class DrushMake <Formula
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.0-beta10.tar.gz'
  homepage 'http://drupal.org/project/drush_make'
  md5 '3be3c6473198652900f7695e09a1806c'
end

class Drush <Formula
  url 'http://ftp.drupal.org/files/projects/drush-7.x-4.0.tar.gz'
  homepage 'http://drupal.org/project/drush'
  version '4.0'
  md5 'dbfba4f79be85122d7173e2ac7531a6b'

  def install
    prefix.install Dir['*'] # No lib folder, so this is OK for now.
    bin.mkpath
    symlink prefix+'drush', bin+'drush'
    DrushMake.new.brew { (prefix+'commands/drush_make').install Dir['*'] }
  end
end
