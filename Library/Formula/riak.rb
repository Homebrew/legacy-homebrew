require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'

  url 'http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.0/osx/10.8/riak-1.4.0-OSX-x86_64.tar.gz'
  version '1.4.0-x86_64'
  sha256 '4830b9e00b520b8494264017bfc2ff10753fd51b9e013bafd3054e29e5be1443'

  depends_on :arch => :x86_64

  # patch scripts to work with homebrew symlinking
  def patches
    [
      "https://gist.github.com/erbmicha/5970803/raw", # env.sh patch
      "https://gist.github.com/erbmicha/5970790/raw", # riak patch
      "https://gist.github.com/erbmicha/5972538/raw", # search-cmd patch
      "https://gist.github.com/erbmicha/5972526/raw", # riak-admin patch
      "https://gist.github.com/erbmicha/5972531/raw", # riak-debug patch
    ]
  end

  def install
    prefix.install Dir['*']
    rm Dir.glob("#{bin}/*.orig") # get rid of the patch backups before symlinking to bin
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
