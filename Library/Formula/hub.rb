require 'formula'

class Hub < Formula
  homepage 'http://hub.github.com/'
  url 'https://github.com/github/hub/archive/v1.11.0.tar.gz'
  sha1 'fea06d242af3be473b78bb738a04afc11ca4df21'
  head 'https://github.com/github/hub.git'

  def install
    rake "install", "prefix=#{prefix}"
    bash_completion.install 'etc/hub.bash_completion.sh'
    zsh_completion.install 'etc/hub.zsh_completion' => '_hub'
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal 'bin/brew', `#{bin}/git ls-files -- bin`.strip
    end
  end
end
