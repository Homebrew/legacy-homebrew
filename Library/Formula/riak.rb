require 'formula'

class Riak < Formula
  homepage 'http://basho.com/riak/'
  url 'http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.8/osx/10.8/riak-1.4.8-OSX-x86_64.tar.gz'
  version '1.4.8'
  sha256 'e1bca241708ca64beb1626e0f640a22f545787365966f87e6cfd4a976682236c'

  devel do
    url 'http://s3.amazonaws.com/downloads.basho.com/riak/2.0/2.0.0pre11/osx/10.8/riak-2.0.0pre11-OSX-x86_64.tar.gz'
    sha1 '555eaf744dffae1e205bb612ea90569144487a29'
    version '2.0.0-pre11'
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
