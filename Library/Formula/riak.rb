require 'formula'

class Riak <Formula
  url 'http://downloads.basho.com/riak/riak-0.12/riak-0.12.0.tar.gz'
  homepage 'http://riak.basho.com'
  md5 'b5bbc7aaf115bc6ba518137b733ad8a2'

  skip_clean 'libexec/log'
  skip_clean 'libexec/log/sasl'
  skip_clean 'libexec/data'
  skip_clean 'libexec/data/dets'
  skip_clean 'libexec/data/ring'

  depends_on 'erlang'

  def patches
    # Having issues with the integer_to_list/2 BIF
    DATA
  end

  def install
    ENV.deparallelize
    system "make all rel"
    %w(riak riak-admin).each do |file|
      inreplace "rel/riak/bin/#{file}", /^RUNNER_BASE_DIR=.+$/, "RUNNER_BASE_DIR=#{libexec}"
    end

    # Install most files to private libexec, and link in the binaries.
    libexec.install Dir["rel/riak/*"]
    bin.mkpath
    ln_s libexec+'bin/riak', bin
    ln_s libexec+'bin/riak-admin', bin

    (prefix + 'data/ring').mkpath
    (prefix + 'data/dets').mkpath
  end
end

__END__
diff --git a/apps/riak_core/src/riak_core_util.erl b/apps/riak_core/src/riak_core_util.erl
index 4c5d73c..e03a95a 100644
--- a/apps/riak_core/src/riak_core_util.erl
+++ b/apps/riak_core/src/riak_core_util.erl
@@ -22,7 +22,7 @@
 
 %% @doc Various functions that are useful throughout Riak.
 -module(riak_core_util).
-
+-compile({no_auto_import,[integer_to_list/2]}).
 -export([moment/0,
          make_tmp_dir/0,
          compare_dates/2,
