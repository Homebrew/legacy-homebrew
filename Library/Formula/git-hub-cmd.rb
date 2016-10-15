class GitHubCmd < Formula
  desc "Interact with GitHub's v3 REST API using the git hub subcommand"
  homepage "https://github.com/ingydotnet/git-hub"
  url "https://github.com/ingydotnet/git-hub/archive/0.1.5.tar.gz"
  sha256 "c057c2c56fa84a389105f935f63a72e5fa3f9fb9412a273d87b403b525ee2225"

  def install
    inreplace "Makefile" do |f|
      # Prevent the makefile from installing outside of the prefix
      f.gsub! "$(shell git --exec-path | sed 's/.*://')", "$(PREFIX)/bin"
    end

    inreplace "lib/git-hub" do |f|
      # Fix the hardcoded directory to match Homebrew's structure
      f.gsub! "SELFDIR=\"$(cd -P `dirname $BASH_SOURCE` && pwd -P)\"", "SELFDIR=#{bin}"
    end

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"git-hub-config").write(<<-EOS.undent
      [git-hub]
      login=test
      api-token=test
      EOS
      )
    output = shell_output("GIT_HUB_CONFIG=#{testpath}/git-hub-config #{bin}/git-hub repo Homebrew/homebrew --dryrun --verbose 2>&1")
    assert output.include? "curl --request GET https://api.github.com/repos/Homebrew/homebrew"
  end
end
