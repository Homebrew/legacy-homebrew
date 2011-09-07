require 'formula'

class Go < Formula
  if ARGV.include? "--use-git"
    url 'https://github.com/tav/go.git', :tag => 'release-branch.r59'
    head 'https://github.com/tav/go.git'
  else
    url 'http://go.googlecode.com/hg/', :revision => 'release.r59'
    head 'http://go.googlecode.com/hg/'
  end
  version 'r59'
  homepage 'http://golang.org'

  skip_clean 'bin'

  def options
    [["--use-git", "Use git mirror instead of official hg repository"]]
  end

  def install
    prefix.install %w[src include test doc misc lib favicon.ico AUTHORS]
    Dir.chdir prefix
    mkdir %w[pkg bin]

    Dir.chdir 'src' do
      # Tests take a very long time to run. Build only
      system "./make.bash"
    end

    # Don't need the src folder, but do keep the Makefiles as Go projects use these
    Dir['src/*'].each{|f| rm_rf f unless f.match(/^src\/(pkg|Make)/) }
    rm_rf %w[include test]
  end
end
