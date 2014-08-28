require "formula"

class GitDashHub < Formula
  version "0.1.3"
  homepage "https://github.com/ingydotnet/git-hub"
  url "https://github.com/ingydotnet/git-hub/archive/github-issue-141-fix/1.tar.gz"
  sha1 "d43cf776dc72aa9e1fcd27271f5225e5277ee379"

  def install
    inreplace 'Makefile' do |f|
      # Prevent the makefile from installing outside of the prefix
      f.gsub! '$(shell git --exec-path | sed \'s/.*://\')', '$(PREFIX)/bin'
    end

    inreplace 'lib/git-hub' do |f|
      # Fix the hardcoded directory to match Homebrew's structure
      f.gsub! "SELFDIR=\"$(cd -P `dirname $BASH_SOURCE` && pwd -P)\"", "SELFDIR=#{bin}"
    end

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "[ -f #{File.join(man1, "git-hub.1")} ]"
    system "[ -f #{File.join(bin, "git-hub")} ]"
  end
end
