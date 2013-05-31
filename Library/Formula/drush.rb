require 'formula'

class Drush < Formula
  homepage 'http://drupal.org/project/drush'
  url 'http://ftp.drupal.org/files/projects/drush-7.x-5.9.tar.gz'
  sha1 '12533dbc7a18f1fef79a1853a8fdb88171f4fed8'

  head 'git://git.drupal.org/project/drush.git', :branch => '8.x-6.x'

  option 'without-completions', 'Disable drush bash completion'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'drush'
    unless build.include? 'without-completions'
      bash_completion.install libexec/'drush.complete.sh' => 'drush'
    end
  end
end
