require 'formula'

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  url 'http://ftp.drupal.org/files/projects/drush-8.x-6.0-beta1.tar.gz'
  sha1 'e7f24717a3b4d5e07df7a9708ff0540f8aae2968'

  head 'git://git.drupal.org/project/drush.git', :branch => '8.x-6.x'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'drush'
    bash_completion.install libexec/'drush.complete.sh' => 'drush'
  end
end
