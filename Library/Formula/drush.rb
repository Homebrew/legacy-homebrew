require 'formula'

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  url 'http://ftp.drupal.org/files/projects/drush-7.x-5.7.tar.gz'
  sha1 'a864ca746f13e539f86030262f943442c75f9c96'

  head 'git://git.drupal.org/project/drush.git'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'drush'
  end
end
