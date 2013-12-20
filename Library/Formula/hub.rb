require 'formula'

class Hub < Formula
  homepage 'http://hub.github.com/'
  url 'https://github.com/github/hub/archive/v1.11.0.tar.gz'
  sha1 'fea06d242af3be473b78bb738a04afc11ca4df21'
  head 'https://github.com/github/hub.git'

  option 'without-completions', 'Disable bash/zsh completions'

  def install
    ENV['GIT_DIR'] = downloader.cached_location/'.git' if build.head?

    rake "install", "prefix=#{prefix}"

    unless build.without? 'completions'
      bash_completion.install 'etc/hub.bash_completion.sh'
      zsh_completion.install 'etc/hub.zsh_completion' => '_hub'
    end
  end

  test do
    system "#{bin}/hub version | grep 'hub version #{version}'"
  end
end
