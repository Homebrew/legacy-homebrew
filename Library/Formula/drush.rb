require 'formula'

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  head 'https://github.com/drush-ops/drush.git'
  url 'https://github.com/drush-ops/drush/archive/6.0.0.tar.gz'
  sha1 '6ff849b5d0807c4c4a39afeed28b9aa2dbc6de5e'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'drush'
    bash_completion.install libexec/'drush.complete.sh' => 'drush'
  end
end
