require 'formula'

class Hub < Formula
  url 'https://github.com/defunkt/hub/tarball/v1.10.2'
  homepage 'http://defunkt.io/hub/'
  head 'https://github.com/defunkt/hub.git'
  sha1 '7520d264249573d7f72c443f1144b67cc645ab9b'

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
