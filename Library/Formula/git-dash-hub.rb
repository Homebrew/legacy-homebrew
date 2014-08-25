require "formula"

class GitDashHub < Formula
  homepage "https://github.com/ingydotnet/git-hub"
  url "https://github.com/ingydotnet/git-hub/archive/0.1.4.tar.gz"
  sha1 "e902e3dc9a3ad1aacda61eabf22011f61bd139c3"

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
