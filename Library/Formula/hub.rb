require 'formula'

class Hub < Formula
  homepage 'http://defunkt.io/hub/'
  url 'https://github.com/defunkt/hub/archive/v1.10.5.tar.gz'
  sha1 '1de6adcc6510f5ca890e55ede0d1fca0b06054cd'
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
