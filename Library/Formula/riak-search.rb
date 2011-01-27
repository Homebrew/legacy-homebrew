require 'formula'

class RiakSearch <Formula
  url 'http://downloads.basho.com/riak-search/riak-search-0.13/riak_search-0.13.0-osx-i386.tar.gz'
  homepage 'http://riak.basho.com'
  md5 '5f6f95a8edf183dc3799b5139b29d7f8'
  version '0.13.0'

  skip_clean 'libexec/log'
  skip_clean 'libexec/log/sasl'
  skip_clean 'libexec/data'
  skip_clean 'libexec/data/dets'
  skip_clean 'libexec/data/ring'

  depends_on 'erlang'

  def install
    ENV.deparallelize
    %w(riaksearch riaksearch-admin search-cmd).each do |file|
      inreplace "bin/#{file}", /^RUNNER_BASE_DIR=.+$/, "RUNNER_BASE_DIR=#{libexec}"
    end

    # Install most files to private libexec, and link in the binaries.
    libexec.install Dir["*"]

    bin.mkpath
    ln_s libexec+'bin/riaksearch', bin
    ln_s libexec+'bin/riaksearch-admin', bin
    ln_s libexec+'bin/search-cmd', bin

    (prefix + 'data/ring').mkpath
    (prefix + 'data/dets').mkpath
  end
end
