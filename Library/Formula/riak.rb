class Riak < Formula
  homepage "http://basho.com/riak/"
  desc "Riak is a distributed NoSQL key-value data store."
  url "https://s3.amazonaws.com/downloads.basho.com/riak/2.1/2.1.1/osx/10.8/riak-2.1.1-OSX-x86_64.tar.gz"
  version "2.1.1"
  sha256 "ee06193b5fc4bb56746f8f648794b732b96879369835a94f22235e0561d652d7"

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

  def recommended_maxfiles
    65536
  end

  def recommended_maxproc
    2048
  end

  def caveats
    msg = nil
    if maxfiles_too_low? || maxprocs_too_low?
      msg = "Your maxfiles limit or maxprocs limit is too low.  See the riak docs:\n"
      msg << "http://docs.basho.com/riak/latest/ops/tuning/open-files-limit/"
    end

    msg
  end

  def maxfiles_too_low?
    maxfiles = `launchctl limit maxfiles`
    _, maxfiles_soft, maxfiles_hard = maxfiles.split

    maxfiles_soft.to_i < recommended_maxfiles || maxfiles_hard.to_i < recommended_maxfiles
  end

  def maxprocs_too_low?
    maxproc= `launchctl limit maxproc`
    _, maxproc_soft, maxproc_hard = maxproc.split

    maxproc_soft.to_i < recommended_maxproc || maxproc_hard.to_i < recommended_maxproc
  end

  test do
    system "#{bin}/riak", "help", "0"
  end
end
