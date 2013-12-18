require 'formula'

class Riak < Formula
  homepage 'http://basho.com/riak/'
  url 'http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.2/osx/10.8/riak-1.4.2-OSX-x86_64.tar.gz'
  version '1.4.2'
  sha256 '2accc58a0ea2f7bd3edc31c934edb0bff6a1535994607fd6cec9c6bbefcf2abf'

  devel do
    url 'http://s3.amazonaws.com/downloads.basho.com/riak/2.0/2.0.0pre5/osx/10.8/riak-2.0.0pre5-OSX-x86_64.tar.gz'
    sha1 '2394a7244329b60afd87307e3362d784a1611689'
    version '2.0.0-pre5'
  end

  depends_on :macos => :mountain_lion
  depends_on :arch => :x86_64

  def install
    libexec.install Dir['*']
    inreplace Dir["#{libexec}/lib/env.sh"] do |s|
      s.change_make_var! "RUNNER_BASE_DIR", prefix/libexec
    end
    bin.write_exec_script libexec/'bin/riak'
    bin.write_exec_script libexec/'bin/riak-admin'
    bin.write_exec_script libexec/'bin/riak-debug'
    bin.write_exec_script libexec/'bin/search-cmd'
  end
end
