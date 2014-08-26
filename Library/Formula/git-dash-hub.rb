require "formula"

class GitDashHub < Formula
  homepage "https://github.com/ingydotnet/git-hub"
  url "https://github.com/ingydotnet/git-hub/archive/0.1.3.tar.gz"
  sha1 "743517bc205ed4e3ac6c3077247d7b49ff249e87"

  def install
    inreplace 'Makefile' do |f|
      # BSD Make does not support -C and -d combined
      f.gsub! 'install -C -d', 'install -d'
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
