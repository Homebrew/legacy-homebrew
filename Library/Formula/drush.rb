require 'formula'

class DrushMake <Formula
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.0-beta9.tar.gz'
  homepage 'http://drupal.org/project/drush_make'
  md5 '971cde5da1fcf8ae63e42c074cbb5476'
end

class Drush <Formula
  url 'http://ftp.drupal.org/files/projects/drush-6.x-3.3.tar.gz'
  homepage 'http://drupal.org/project/drush'
  version '3.3' # 3.3 is detected, but lets be explicit here
  md5 'ed7ee13415548c643358a8a870534a5e'

  def install
    prefix.install Dir['*'] # No lib folder, so this is OK for now.
    bin.mkpath
    symlink prefix+'drush', bin+'drush'
    DrushMake.new.brew { (prefix+'commands/drush_make').install Dir['*'] }
  end
end
