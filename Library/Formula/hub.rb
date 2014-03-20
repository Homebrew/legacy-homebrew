require 'formula'

class Hub < Formula
  homepage 'http://hub.github.com/'
  url 'https://github.com/github/hub/archive/v1.12.0.tar.gz'
  sha1 '195b7c92b49286623baa4d01ab53b8a898b484a2'
  head 'https://github.com/github/hub.git'

  option 'without-completions', 'Disable bash/zsh completions'

  def install
    ENV['GIT_DIR'] = cached_download/'.git' if build.head?

    rake "install", "prefix=#{prefix}"

    if build.with? 'completions'
      bash_completion.install 'etc/hub.bash_completion.sh'
      zsh_completion.install 'etc/hub.zsh_completion' => '_hub'
    end
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal 'bin/brew', `#{bin}/hub ls-files -- bin`.strip
    end
  end
end
