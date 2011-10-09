require 'formula'

class Go < Formula
  if ARGV.include? "--use-git"
    url 'https://github.com/tav/go.git', :ref => '8ec59f48bc' # git mirror isn't getting tags
    head 'https://github.com/tav/go.git'
  else
    url 'http://go.googlecode.com/hg/', :revision => 'release.r60.1'
    head 'http://go.googlecode.com/hg/'
  end
  version 'r60.1'
  homepage 'http://golang.org'

  skip_clean 'bin'

  def options
    [["--use-git", "Use git mirror instead of official hg repository"]]
  end

  def install
    prefix.install %w[src include test doc misc lib favicon.ico AUTHORS]
    Dir.chdir prefix
    mkdir %w[pkg bin]
    File.open('VERSION', 'w') {|f| f.write('release.r60.1 9781') }

    Dir.chdir 'src' do
      # Tests take a very long time to run. Build only
      system "./make.bash"
    end

    # Don't need the src folder, but do keep the Makefiles as Go projects use these
    Dir['src/*'].each{|f| rm_rf f unless f.match(/^src\/(pkg|Make)/) }
    rm_rf %w[include test]
  end
end
