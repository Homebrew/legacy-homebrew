require "formula"

class Riak < Formula
  homepage "http://basho.com/riak/"
  url "https://s3.amazonaws.com/downloads.basho.com/riak/2.0/2.0.2/osx/10.8/riak-2.0.2-OSX-x86_64.tar.gz"
  version "2.0.2"
  sha256 "a21178c02110f26e5f1f990ceca10c0d62516265d957450ba6fc7b98e963c76d"

  depends_on :macos => :mountain_lion
  depends_on :arch => :x86_64

  def install
    logdir = var + "log/riak"
    datadir = var + "lib/riak"
    libexec.install Dir["*"]
    logdir.mkpath
    datadir.mkpath
    (datadir + "ring").mkpath
    inreplace "#{libexec}/lib/env.sh" do |s|
      s.change_make_var! "RUNNER_BASE_DIR", libexec
      s.change_make_var! "RUNNER_LOG_DIR", logdir
    end
    inreplace "#{libexec}/etc/riak.conf" do |c|
      c.gsub! /(platform_data_dir *=).*$/, "\\1 #{datadir}"
      c.gsub! /(platform_log_dir *=).*$/, "\\1 #{logdir}"
    end
    bin.write_exec_script libexec/"bin/riak"
    bin.write_exec_script libexec/"bin/riak-admin"
    bin.write_exec_script libexec/"bin/riak-debug"
    bin.write_exec_script libexec/"bin/search-cmd"
  end
end
