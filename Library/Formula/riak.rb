require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'
  url 'http://downloads.basho.com/riak/riak-1.1.0/riak-1.1.0.tar.gz'
  md5 'b240b920eb037e751fbd22ede6ebba61'

  head 'https://github.com/basho/riak.git'

  skip_clean 'libexec/log'
  skip_clean 'libexec/log/sasl'
  skip_clean 'libexec/data'
  skip_clean 'libexec/data/dets'
  skip_clean 'libexec/data/ring'

  depends_on 'erlang'

  def install
    ENV.deparallelize
    system "make all rel"
    %w(riak riak-admin search-cmd).each do |file|
      inreplace "rel/riak/bin/#{file}", /^RUNNER_BASE_DIR=.+$/, "RUNNER_BASE_DIR=#{libexec}"
    end

    # Install most files to private libexec, and link in the binaries.
    libexec.install Dir["rel/riak/*"]
    bin.install_symlink libexec+'bin/riak',
                        libexec+'bin/riak-admin',
                        libexec+'bin/search-cmd'

    (prefix + 'data/ring').mkpath
    (prefix + 'data/dets').mkpath

    # Install man pages
    man1.install Dir["doc/man/man1/*"]
  end
end
