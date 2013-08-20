require 'formula'

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  url 'http://ftp.drupal.org/files/projects/drush-8.x-6.0-rc4.tar.gz'
  sha1 '66a96f3540e9502b86385b1c62358b839410ac92'

  head 'git://git.drupal.org/project/drush.git', :branch => '8.x-6.x'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'drush'
    bash_completion.install libexec/'drush.complete.sh' => 'drush'
  end
end
