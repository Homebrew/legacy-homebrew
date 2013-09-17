require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'
  url 'http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.2/osx/10.8/riak-1.4.2-OSX-x86_64.tar.gz'
  version '1.4.2'
  sha256 '2accc58a0ea2f7bd3edc31c934edb0bff6a1535994607fd6cec9c6bbefcf2abf'

  depends_on :macos => :mountain_lion
  depends_on :arch => :x86_64

  def install
    prefix.install Dir['*']
    inreplace Dir["#{lib}/env.sh"] do |s|
      s.change_make_var! "RUNNER_BASE_DIR", prefix
    end
  end
end
