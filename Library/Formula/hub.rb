require 'formula'

class Hub < Formula
  url 'https://github.com/defunkt/hub/tarball/v1.8.4'
  homepage 'http://defunkt.io/hub/'
  head 'https://github.com/defunkt/hub.git'
  md5 '1ca041817c014d2d3a5267f2aed4157b'

  def install
    system "rake", "install", "prefix=#{prefix}"
    (prefix+'etc/bash_completion.d').install 'etc/hub.bash_completion.sh'
    (share+'zsh/site-functions').install 'etc/hub.zsh_completion' => '_hub'
  end

  def caveats; <<-EOS.undent
    Bash completion has been installed to:
      #{etc}/bash_completion.d

    zsh completion has been installed to:
      #{HOMEBREW_PREFIX}/share/zsh/site-functions
    EOS
  end
end
