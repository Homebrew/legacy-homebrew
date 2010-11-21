require 'formula'
require 'hardware'

class Go <Formula
  if ARGV.include? "--use-git-head"
    head 'https://github.com/tav/go.git', :tag => 'release'
  else
    head 'http://go.googlecode.com/hg/', :revision => 'release'
  end
  homepage 'http://golang.org'

  def options
    [["--use-git-head", "Use git mirror instead of official hg repository"]]
  end

  skip_clean 'bin'

  def which_arch
    Hardware.is_64_bit? ? 'amd64' : '386'
  end

  def install
    ENV.j1 # https://github.com/mxcl/homebrew/issues/#issue/237
    prefix.install %w[src include test doc misc lib favicon.ico]
    Dir.chdir prefix
    mkdir %w[pkg bin]

    ENV['GOROOT'] = Dir.getwd
    ENV['GOBIN'] = bin
    ENV['GOARCH'] = which_arch
    ENV['GOOS'] = 'darwin'

    ENV.prepend 'PATH', ENV['GOBIN'], ':'

    Dir.chdir 'src' do
      system "./all.bash"
      # Keep the makefiles - https://github.com/mxcl/homebrew/issues/issue/1404
    end

    Dir['src/*'].each{|f| rm_rf f unless f.match(/^src\/(pkg|Make)/) }
    rm_rf %w[include test]
  end

  def caveats
    <<-EOS.undent
      The official Go code repository uses mercurial, but a reasonably
      up-to-date git mirror is available at https://github.com/tav/go.git.
      To use the git mirror for Go builds, use the --use-git-head option.

      In order to use Go, set the following in your ~/.profile:

        export GOROOT=`brew --cellar go`
        export GOBIN=#{HOMEBREW_PREFIX}/bin
        export GOARCH=#{which_arch}
        export GOOS=darwin

      Presumably at some point the Go developers won't require us to
      mutilate our shell environments in order to compile Go code...
    EOS
  end
end
