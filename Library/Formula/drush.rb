require 'formula'

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  url 'http://ftp.drupal.org/files/projects/drush-7.x-5.7.tar.gz'
  sha1 '2f96f5ea655eb8810a8087c5e7a6f807'

  head 'git://git.drupal.org/project/drush.git'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'drush'
  end
end
