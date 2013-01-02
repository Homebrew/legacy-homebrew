require 'formula'

class Hub < Formula
  homepage 'http://defunkt.io/hub/'
  url 'https://github.com/defunkt/hub/tarball/v1.10.4'
  sha1 'b43f69f20563cb779d77a6beaf773bad8c49ad4c'

  head 'https://github.com/defunkt/hub.git'

  def install
    system rake_bin, "install", "prefix=#{prefix}"
    (prefix+'etc/bash_completion.d').install 'etc/hub.bash_completion.sh'
    (share+'zsh/site-functions').install 'etc/hub.zsh_completion' => '_hub'
  end

  def rake_bin
    require 'rbconfig'
    ruby_rake = File.join RbConfig::CONFIG['bindir'], 'rake'

    if File.exist? ruby_rake
      ruby_rake
    else
      '/usr/bin/rake'
    end
  end
end
