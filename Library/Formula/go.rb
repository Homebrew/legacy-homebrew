require 'formula'

class Go <Formula
  head 'https://go.googlecode.com/hg/', :revision => 'release'
  homepage 'http://golang.org'

  aka 'google-go'

  skip_clean 'bin'

  def cruft
    %w[src include test doc]
  end

  def install
    ENV.j1 # http://github.com/mxcl/homebrew/issues/#issue/237
    prefix.install cruft<<'misc'
    Dir.chdir prefix
    FileUtils.mkdir %w[pkg bin lib]

    ENV['GOROOT'] = Dir.getwd
    ENV['GOBIN'] = bin.to_s
    ENV['GOARCH'] = Hardware.is_64_bit? ? 'amd64' : '386'
    ENV['GOOS'] = 'darwin'

    ENV.prepend 'PATH', ENV['GOBIN'], ':'

    Dir.chdir 'src' do
      system "./all.bash"
    end

    FileUtils.rm_rf cruft
  end

  def caveats; <<-EOS
In order to use Go you need to set the following in your ~/.profile:

    export GOROOT=`brew --cellar`/go/#{version}
    export GOARCH=#{ENV['GOARCH']}
    export GOOS=#{ENV['GOOS']}

Presumably at some point the Go developers won't require us to mutilate our
shell environments in order to compile Go code...
    EOS
  end
end
