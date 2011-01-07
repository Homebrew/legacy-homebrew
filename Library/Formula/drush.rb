require 'formula'

class DrushMake <Formula
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.0-beta10.tar.gz'
  homepage 'http://drupal.org/project/drush_make'
  md5 '3be3c6473198652900f7695e09a1806c'
end

class Drush <Formula
  url 'http://ftp.drupal.org/files/projects/drush-6.x-4.0-rc7.tar.gz'
  homepage 'http://drupal.org/project/drush'
  version '4.0-rc7'
  md5 '327e09a3fd9eef6c918ea1eac2ceb312'

  def install
    prefix.install Dir['*'] # No lib folder, so this is OK for now.
    bin.mkpath
    symlink prefix+'drush', bin+'drush'
    DrushMake.new.brew { (prefix+'commands/drush_make').install Dir['*'] }
  end
end
