require 'formula'

class DrushMake <Formula
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.0-beta8.tar.gz'
  homepage 'http://drupal.org/project/drush_make'
  md5 '75c2d4b1ae7f69f843d641723f4aae5a'
end

class Drush <Formula
  url 'http://ftp.drupal.org/files/projects/drush-6.x-3.1.tar.gz'
  homepage 'http://drupal.org/project/drush'
  version '3.1' # 3.1 is detected, but lets be explicit here
  md5 'e768e504674428879a047d8cfdd4926f'

  def install
    prefix.install Dir['*'] # No lib folder, so this is OK for now.
    bin.mkpath
    symlink prefix+'drush', bin+'drush'
    DrushMake.new.brew { (prefix+'commands/drush_make').install Dir['*'] }
  end
end
