require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'
  url 'http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.1/osx/10.8/riak-1.4.1-OSX-x86_64.tar.gz'
  version '1.4.1'
  sha256 'ebe68fb9fa2ee87636d2e8bb38d3a8e805c61edbd329fdf648e68933aae79668'

  depends_on :macos => :mountain_lion
  depends_on :arch => :x86_64

  def install
    prefix.install Dir['*']
    inreplace Dir["#{lib}/env.sh"] do |s|
      s.change_make_var! "RUNNER_BASE_DIR", prefix
    end
  end
end
