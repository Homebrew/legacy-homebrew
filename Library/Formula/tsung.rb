require 'formula'

class Tsung < Formula
  homepage 'http://tsung.erlang-projects.org/'
  url 'http://tsung.erlang-projects.org/dist/tsung-1.5.0.tar.gz'
  sha1 '29cc209045ae7bc4aea1c9ab8269758135dbde27'

  depends_on 'erlang'
  depends_on 'gnuplot'

  # Patch for https://support.process-one.net/browse/TSUN-299
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
__END__
diff --git a/src/tsung/ts_jabber.erl b/src/tsung/ts_jabber.erl
index 45b0bf2..5500418 100644
--- a/src/tsung/ts_jabber.erl
+++ b/src/tsung/ts_jabber.erl
@@ -181,7 +181,6 @@ presence_bidi(RcvdXml, State)->
     bidi_resp(subscribed,RcvdXml,SubMatches,State).
 
 starttls_bidi(_RcvdXml, #state_rcv{socket= Socket}=State)->
-    ssl:start(),
     {ok, SSL} = ts_ssl:connect(Socket, []),
     ?LOGF("Upgrading to TLS : ~p",[SSL],?INFO),
     {nodata, State#state_rcv{socket=SSL,protocol=ts_ssl}}.
diff --git a/src/tsung/tsung.erl b/src/tsung/tsung.erl
index 3f9029b..0b47c17 100644
--- a/src/tsung/tsung.erl
+++ b/src/tsung/tsung.erl
@@ -39,6 +39,7 @@
 %%----------------------------------------------------------------------
 start(_Type, _StartArgs) ->
 % error_logger:tty(false),
+    ssl:start(),
     ?LOG("open logfile  ~n",?DEB),
     LogFileEnc = ts_config_server:decode_filename(?config(log_file)),
     LogFile = filename:join(LogFileEnc, atom_to_list(node()) ++ ".log"),
