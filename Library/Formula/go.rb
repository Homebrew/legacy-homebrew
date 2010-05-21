require 'formula'
require 'hardware'

class Go <Formula
  head 'http://go.googlecode.com/hg/', :revision => 'release'
  homepage 'http://golang.org'

  aka 'google-go'

  skip_clean 'bin'

  def cruft
    %w[src include test doc]
  end

  def which_arch
    Hardware.is_64_bit? ? 'amd64' : '386'
  end

  def install
    ENV.j1 # http://github.com/mxcl/homebrew/issues/#issue/237
    prefix.install %w[src include test doc misc]
    Dir.chdir prefix
    mkdir %w[pkg bin lib]

    ENV['GOROOT'] = Dir.getwd
    ENV['GOBIN'] = bin
    ENV['GOARCH'] = which_arch
    ENV['GOOS'] = 'darwin'

    ENV.prepend 'PATH', ENV['GOBIN'], ':'

    Dir.chdir 'src' do
      system "./all.bash"
      # Keep the makefiles - http://github.com/mxcl/homebrew/issues/issue/1404
    end

    Dir['src/*'].each{|f| rm_rf f unless f.match(/^src\/Make/) }
    rm_rf %w[include test doc]
  end

  def caveats
    <<-EOS.undent
      In order to use Go, set the following in your ~/.profile:

        export GOROOT=`brew --cellar`/go/#{version}
        export GOBIN=#{HOMEBREW_PREFIX}/bin
        export GOARCH=#{which_arch}
        export GOOS=darwin

      Presumably at some point the Go developers won't require us to
      mutilate our shell environments in order to compile Go code...
    EOS
  end
end
