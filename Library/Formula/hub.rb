require 'formula'

class Hub < Formula
  homepage 'http://hub.github.com/'
  url 'https://github.com/github/hub/archive/v1.12.4.tar.gz'
  sha1 '25135167108cd777ba6ec2dd5a9a25e248d98d4b'

  head do
    url "https://github.com/github/hub.git"
    depends_on "go" => :build
  end

  option 'without-completions', 'Disable bash/zsh completions'

  def install
    if build.head?
      ENV["GIT_DIR"] = cached_download/".git"
      system "script/build"
      bin.install "hub"
    else
      rake "install", "prefix=#{prefix}"
    end

    if build.with? 'completions'
      bash_completion.install 'etc/hub.bash_completion.sh'
      zsh_completion.install 'etc/hub.zsh_completion' => '_hub'
    end
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal "bin/brew", shell_output("#{bin}/hub ls-files -- bin").strip
    end
  end
end
