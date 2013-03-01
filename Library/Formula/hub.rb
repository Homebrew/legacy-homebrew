require 'formula'

class Hub < Formula
  homepage 'http://defunkt.io/hub/'
  url 'https://github.com/defunkt/hub/tarball/v1.10.4'
  sha1 'b43f69f20563cb779d77a6beaf773bad8c49ad4c'
  head 'https://github.com/defunkt/hub.git'

  def install
    rake "install", "prefix=#{prefix}"
    bash_completion.install 'etc/hub.bash_completion.sh'
    zsh_completion.install 'etc/hub.zsh_completion' => '_hub'
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      `#{bin}/hub ls-files -- bin`.chomp == 'bin/brew'
    end
  end
end
