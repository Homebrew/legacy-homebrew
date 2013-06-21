require 'formula'

class Hub < Formula
  homepage 'http://defunkt.io/hub/'
  url 'https://github.com/defunkt/hub/archive/v1.10.6.tar.gz'
  sha1 'e29d158c65a10ef3889f4af438bf1fb50fbd0536'
  head 'https://github.com/defunkt/hub.git'

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
