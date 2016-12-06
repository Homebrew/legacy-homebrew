require 'formula'

class Drush6 < Formula
  homepage 'http://drupal.org/project/drush'
  url 'http://ftp.drupal.org/files/projects/drush-8.x-6.0-beta1.tar.gz'
  sha1 'e7f24717a3b4d5e07df7a9708ff0540f8aae2968'

  # 8.x-6.0-beta1 (http://drupalcode.org/project/drush.git/tree/77328df783d36aa2cf74b4fcb4ee90ae7ff21994)
  head 'git://git.drupal.org/project/drush.git', :tag => '8.x-6.0-beta1'

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/drush" => "drush6"
    system "ln -s #{bin}/drush6 #{HOMEBREW_PREFIX}/bin/drush6"
  end
end
