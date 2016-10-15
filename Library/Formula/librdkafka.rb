require "formula"

class Librdkafka < Formula
  homepage "https://github.com/edenhill/librdkafka"

  url 'https://github.com/edenhill/librdkafka.git', :tag => "0.8.3"
  sha1 "02437c9d2d3c9db7fdce47cb2c303b6bf927f9a8"

  patch :DATA

  def install
    ENV["DESTDIR"] = prefix

    system "make", "librdkafka.so.1"
    system "make", "librdkafka.a"
    system "make", "libs"
    system "make", "all"
    system "make", "install"
  end
end

__END__
diff --git a/Makefile b/Makefile
index f592db2..2f02677 100755
--- a/Makefile
+++ b/Makefile
@@ -77,11 +77,6 @@ examples: .PHONY

 install:
 	@echo "\033[33mInstall to root $(DESTDIR)\033[0m"
-	if [ "$(DESTDIR)" != "/usr/local" ]; then \
-		DESTDIR="$(DESTDIR)/usr"; \
-	else \
-		DESTDIR="$(DESTDIR)" ; \
-	fi ; \
 	install -d $$DESTDIR/include/librdkafka $$DESTDIR/lib ; \
 	install $(HDRS) $$DESTDIR/include/$(LIBNAME) ; \
 	install $(LIBNAME).a $$DESTDIR/lib ; \
@@ -107,8 +102,8 @@ check:
 	$$($$RET))

 	@(printf "%-30s " "Symbol visibility" ; \
-	((nm -D librdkafka.so.1 | grep -q rd_kafka_new) && \
-	  (nm -D librdkafka.so.1 | grep -vq rd_kafka_destroy) && \
+	((nm librdkafka.so.1 | grep -q rd_kafka_new) && \
+	  (nm librdkafka.so.1 | grep -vq rd_kafka_destroy) && \
 		echo "\033[32mOK\033[0m") || \
 	  echo "\033[31mFAILED\033[0m")

diff --git a/examples/Makefile b/examples/Makefile
index d37dd5f..6e35493 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -1,7 +1,7 @@
 EXAMPLES ?= rdkafka_example rdkafka_performance
 CC ?= cc
 CXX ?= g++
-CFLAGS += -g -Wall -Werror -Wfloat-equal -Wpointer-arith -O2 -I../
+CFLAGS += -Wall -Werror -Wfloat-equal -Wpointer-arith -O2 -I../
 CXXFLAGS += $(CFLAGS)
 LDFLAGS +=  ../librdkafka.a
 LDFLAGS += -lpthread -lz
