require 'formula'

class Drush < Formula
  homepage 'https://github.com/drush-ops/drush'
  head 'https://github.com/drush-ops/drush.git'
  url 'https://github.com/drush-ops/drush/archive/6.3.0.tar.gz'
  sha1 '90fde5acfbd6feefad02453ee9f31a0ac6d2f80e'

  def install
    prefix.install_metafiles
    libexec.install Dir['*'] - ['drush.bat']
    (bin+'drush').write <<-EOS.undent
      #!/bin/sh

      export ETC_PREFIX=${ETC_PREFIX:=#{HOMEBREW_PREFIX}}
      export SHARE_PREFIX=${SHARE_PREFIX:=#{HOMEBREW_PREFIX}}

      exec "#{libexec}/drush" "$@"
    EOS
    bash_completion.install libexec/'drush.complete.sh' => 'drush'
  end
end
