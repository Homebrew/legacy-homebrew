require "formula"

class Riak < Formula
  homepage "http://basho.com/riak/"
  url "http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.9/osx/10.8/riak-1.4.9-OSX-x86_64.tar.gz"
  version "1.4.9"
  sha256 "50dd4a423539ed309fc983820e9cfde250be2927efd85c3e8c0dff9281d63ab5"

  devel do
    url "http://s3.amazonaws.com/downloads.basho.com/riak/2.0/2.0.0beta1/osx/10.8/riak-2.0.0beta1-OSX-x86_64.tar.gz"
    sha256 "1138e40091d4b1a04d497f8c85c62a2594b269da32fcb1154657ea622c52a3fc"
    version "2.0.0-beta1"
  end

  depends_on :macos => :mountain_lion
  depends_on :arch => :x86_64

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}/lib/env.sh" do |s|
      s.change_make_var! "RUNNER_BASE_DIR", libexec
    end
    bin.write_exec_script libexec/"bin/riak"
    bin.write_exec_script libexec/"bin/riak-admin"
    bin.write_exec_script libexec/"bin/riak-debug"
    bin.write_exec_script libexec/"bin/search-cmd"
  end
end
