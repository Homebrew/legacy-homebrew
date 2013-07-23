require 'formula'

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  url 'http://ftp.drupal.org/files/projects/drush-8.x-6.0-rc2.tar.gz'
  sha1 '73923e3ea35131a1aad76a67eeba2e1c21942fef'

  head 'git://git.drupal.org/project/drush.git', :branch => '8.x-6.x'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'drush'
    bash_completion.install libexec/'drush.complete.sh' => 'drush'
  end
end
