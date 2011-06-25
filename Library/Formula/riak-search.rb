require 'formula'

class RiakSearch < Formula
  url 'http://downloads.basho.com/riak-search/riak-search-0.14/riak_search-0.14.2.tar.gz'
  homepage 'http://riak.basho.com'
  md5 '4dc7cfbd2c985fcb1b73fc5ac8864031'

  head 'https://github.com/basho/riak_search.git'

  skip_clean 'libexec/log'
  skip_clean 'libexec/log/sasl'
  skip_clean 'libexec/data'
  skip_clean 'libexec/data/dets'
  skip_clean 'libexec/data/ring'

  depends_on 'erlang'

  def install
    ENV.deparallelize
    system "make all rel"
    %w(riaksearch riaksearch-admin search-cmd).each do |file|
      inreplace "rel/riaksearch/bin/#{file}", /^RUNNER_BASE_DIR=.+$/, "RUNNER_BASE_DIR=#{libexec}"
    end

    # Install most files to private libexec, and link in the binaries.
    libexec.install Dir["rel/riaksearch/*"]

    bin.mkpath
    ln_s libexec+'bin/riaksearch', bin
    ln_s libexec+'bin/riaksearch-admin', bin
    ln_s libexec+'bin/search-cmd', bin

    (prefix + 'data/ring').mkpath
    (prefix + 'data/dets').mkpath

    # Install man pages
    man1.install Dir["doc/man/man1/*"]
  end
end
