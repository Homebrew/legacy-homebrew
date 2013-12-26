require 'formula'

class Hub < Formula
  homepage 'http://hub.github.com/'
  url 'https://github.com/github/hub/archive/v1.11.1.tar.gz'
  sha1 '1b7f1224be6ca0f88a9bfacd686cb2a20cc6fbef'
  head 'https://github.com/github/hub.git'

  option 'without-completions', 'Disable bash/zsh completions'

  def install
    ENV['GIT_DIR'] = downloader.cached_location/'.git' if build.head?

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
