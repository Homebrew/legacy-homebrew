require 'formula'

class Drush < Formula
  homepage 'https://github.com/drush-ops/drush'
  head 'https://github.com/drush-ops/drush.git'
  url 'https://github.com/drush-ops/drush/archive/6.1.0.tar.gz'
  sha1 '81b963e91ff1cb8617e8ed974ac07bb25f509bcf'

  def install
    prefix.install_metafiles
    libexec.install Dir['*'] -['drush.bat']
    bin.install_symlink libexec/'drush'
    bash_completion.install libexec/'drush.complete.sh' => 'drush'
  end
end
