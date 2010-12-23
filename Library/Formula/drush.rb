require 'formula'

class DrushMake <Formula
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.0-beta10.tar.gz'
  homepage 'http://drupal.org/project/drush_make'
  md5 '3be3c6473198652900f7695e09a1806c'
end

class Drush <Formula
  url 'http://ftp.drupal.org/files/projects/drush-6.x-4.0-rc3.tar.gz'
  homepage 'http://drupal.org/project/drush'
  version '4.0-rc3' # Lets be explicit here
  md5 '87659a5b3559f9eb7ef0a16c320a01ad'

  def install
    prefix.install Dir['*'] # No lib folder, so this is OK for now.
    bin.mkpath
    symlink prefix+'drush', bin+'drush'
    DrushMake.new.brew { (prefix+'commands/drush_make').install Dir['*'] }
  end
end
