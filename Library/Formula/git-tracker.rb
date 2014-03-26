require 'formula'

class GitTracker < Formula
  homepage 'https://github.com/stevenharman/git_tracker'
  url 'https://github.com/stevenharman/git_tracker/archive/v1.6.2.tar.gz'
  sha1 'fd0495f3b593b3fbec3104d83faace441893d570'

  head 'https://github.com/stevenharman/git_tracker.git'

  def install
    rake 'standalone:install', "prefix=#{prefix}"
  end

  test do
    require 'open3'
    Open3.popen3("#{bin}/git-tracker", "help") do |_, stdout, _|
      install_message = /\Agit-tracker \d+(\.\d+)* is installed\.\z/
      assert install_message.match(stdout.readline.strip), "git-tracker is not installed"
    end
  end
end
