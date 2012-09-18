require 'formula'

class Spiped < Formula
  homepage 'http://www.tarsnap.com/spiped.html'
  url 'https://www.tarsnap.com/spiped/spiped-1.2.1.tgz'
  sha256 '4e2e532b2a7df8e9a771c27a1bc2889f0d834e986d4f4a02a2a12174560ea44b'

  depends_on :bsdmake => :build

  # - Removes ``-lrt'' from LDADD.
  # - Fixes a typo in spipe README.
  def patches
    DATA
  end

  def install
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "install"
    doc.install 'spiped/README' => 'README.spiped',
                'spipe/README' => 'README.spipe'
  end
end

__END__
diff --git a/spipe/Makefile b/spipe/Makefile
index 873dd5f..3818f53 100644
--- a/spipe/Makefile
+++ b/spipe/Makefile
@@ -2,7 +2,7 @@
 PROG=spipe
 SRCS=main.c pushbits.c proto_conn.c proto_crypt.c proto_handshake.c proto_pipe.c sha256.c elasticarray.c ptrheap.c timerqueue.c asprintf.c daemonize.c entropy.c monoclock.c sock.c warnp.c events_immediate.c events_network.c events_timer.c events.c network_accept.c network_buf.c network_connect.c crypto_aesctr.c crypto_dh.c crypto_dh_group14.c crypto_entropy.c crypto_verify_bytes.c
 IDIRS=-I ../proto -I ../lib/alg -I ../lib/datastruct -I ../lib/util -I ../lib/events -I ../lib/network -I ../lib/crypto
-LDADD=-lrt -lcrypto -lpthread
+LDADD=-lcrypto -lpthread

 all: ${PROG}

diff --git a/spiped/Makefile b/spiped/Makefile
index 91533b9..28b8a35 100644
--- a/spiped/Makefile
+++ b/spiped/Makefile
@@ -2,7 +2,7 @@
 PROG=spiped
 SRCS=main.c dispatch.c proto_conn.c proto_crypt.c proto_handshake.c proto_pipe.c sha256.c elasticarray.c ptrheap.c timerqueue.c asprintf.c daemonize.c entropy.c monoclock.c sock.c warnp.c events_immediate.c events_network.c events_timer.c events.c network_accept.c network_buf.c network_connect.c crypto_aesctr.c crypto_dh.c crypto_dh_group14.c crypto_entropy.c crypto_verify_bytes.c
 IDIRS=-I ../proto -I ../lib/alg -I ../lib/datastruct -I ../lib/util -I ../lib/events -I ../lib/network -I ../lib/crypto
-LDADD=-lrt -lcrypto
+LDADD=-lcrypto

 all: ${PROG}

diff --git a/spipe/README b/spipe/README
index 9bb731b..c0b8177 100644
--- a/spipe/README
+++ b/spipe/README
@@ -1,7 +1,7 @@
 spipe usage
 ===========

-usage: spiped -t <target socket> -k <key file> [-f] [-o <connection timeout>]
+usage: spipe -t <target socket> -k <key file> [-f] [-o <connection timeout>]

 Options:
     -t <target socket>
