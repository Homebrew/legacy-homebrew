require 'formula'

class DrushMake <Formula
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.0-beta10.tar.gz'
  homepage 'http://drupal.org/project/drush_make'
  md5 '3be3c6473198652900f7695e09a1806c'
end

class Drush <Formula
  url 'http://ftp.drupal.org/files/projects/drush-All-versions-4.2.tar.gz'
  homepage 'http://drupal.org/project/drush'
  md5 '0e9f6f42c600f7fd0b7a38ce0f6f2f59'

  def install
    prefix.install Dir['*'] # No lib folder, so this is OK for now.
    bin.mkpath
    symlink prefix+'drush', bin+'drush'
    DrushMake.new.brew { (prefix+'commands/drush_make').install Dir['*'] }
  end

  def patches
    # explanation and source: http://drupal.org/node/1078318
    # remove this for any version above 4.2
    "http://drupal.org/files/issues/drush-1078318.patch"
  end
end
