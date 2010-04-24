require 'formula'

class Riak <Formula
  depends_on 'erlang'
  
  url 'http://downloads.basho.com/riak/riak-0.10/riak-0.10.tar.gz'
  homepage 'http://riak.basho.com'
  md5 'ff745b0c9a52b8741256602afae22a09'
  
  skip_clean 'log'
  skip_clean 'log/sasl'
  skip_clean 'data'
  skip_clean 'data/dets'
  skip_clean 'data/ring'
  
  def install
    ENV.deparallelize
    system "make all rel"
    %w(riak riak-admin).each do |file|
      inreplace "rel/riak/bin/#{file}", /^RUNNER_SCRIPT_DIR.+$/, ""
      inreplace "rel/riak/bin/#{file}", /^RUNNER_BASE_DIR=.+$/, "RUNNER_BASE_DIR=#{prefix}"
    end
    system "mv rel/riak/* #{prefix}"
    (prefix + 'data/ring').mkpath
    (prefix + 'data/dets').mkpath
  end
end
