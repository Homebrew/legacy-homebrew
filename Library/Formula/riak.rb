require "formula"

class Riak < Formula
  homepage "http://basho.com/riak/"
  url "http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.10/osx/10.8/riak-1.4.10-OSX-x86_64.tar.gz"
  version "1.4.10"
  sha256 "32f2d4ee89c6b7fd596726e9b385b5d1715a789413b4e7301d0b0da1c4f711e1"

  devel do
    url "http://s3.amazonaws.com/downloads.basho.com/riak/2.0/2.0.0rc1/osx/10.8/riak-2.0.0rc1-OSX-x86_64.tar.gz"
    sha256 "785c93fb98ce2ab21ffc7644756bed95c9ba1eae46283536609fa93b0287909d"
    version "2.0.0-rc1"
  end

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
    if build.devel?
      inreplace "#{libexec}/etc/riak.conf" do |c|
        c.gsub! /(platform_data_dir *=).*$/, "\\1 #{datadir}"
        c.gsub! /(platform_log_dir *=).*$/, "\\1 #{logdir}"
      end
    else
      inreplace "#{libexec}/etc/app.config" do |c|
        c.gsub! './data', datadir
        c.gsub! './log', logdir
      end
    end
    bin.write_exec_script libexec/"bin/riak"
    bin.write_exec_script libexec/"bin/riak-admin"
    bin.write_exec_script libexec/"bin/riak-debug"
    bin.write_exec_script libexec/"bin/search-cmd"
  end
end
