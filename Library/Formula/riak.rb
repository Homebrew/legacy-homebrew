require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'
  url 'http://downloads.basho.com/riak/riak-1.0.3/riak-1.0.3.tar.gz'
  md5 '433d2cb0c6eba0b6d374d9d37f7f54fe'

  head 'https://github.com/basho/riak.git'

  skip_clean 'libexec/log'
  skip_clean 'libexec/log/sasl'
  skip_clean 'libexec/data'
  skip_clean 'libexec/data/dets'
  skip_clean 'libexec/data/ring'

  depends_on 'erlang'

  # Enable use of Erlang R14B04; fixed in the upstream 1.1.0 pre-release.
  def patches; DATA; end

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

__END__
diff --git a/rebar.config b/rebar.config
index ee81bfc..31d2fae 100644
--- a/rebar.config
+++ b/rebar.config
@@ -1,6 +1,6 @@
 {sub_dirs, ["rel"]}.
 
-{require_otp_vsn, "R14B0[23]"}.
+{require_otp_vsn, "R14B0[234]"}.
 
 {cover_enabled, true}.
 
