require 'formula'

class Beanstalk < Formula
  url 'http://xph.us/dist/beanstalkd/beanstalkd-1.4.6.tar.gz'
  md5 '3dbbb64a6528efaaaa841ea83b30768e'
  homepage 'http://xph.us/software/beanstalkd/'

  depends_on 'libevent'

  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-event=#{HOMEBREW_PREFIX}"

    system "make install"
  end
end

__END__
diff --git a/prot.c b/prot.c
index 481b0ed..8dd34ec 100644
--- a/prot.c
+++ b/prot.c
@@ -305,7 +305,7 @@ reply(conn c, const char *line, int len, int state)
     c->reply_len = len;
     c->reply_sent = 0;
     c->state = state;
-    dprintf("sending reply: %.*s", len, line);
+    dbgprintf("sending reply: %.*s", len, line);
 }
 
 #define reply_msg(c,m) reply((c),(m),CONSTSTRLEN(m),STATE_SENDWORD)
@@ -382,10 +382,10 @@ next_eligible_job(usec now)
     size_t i;
     job j = NULL, candidate;
 
-    dprintf("tubes.used = %zu\n", tubes.used);
+    dbgprintf("tubes.used = %zu\n", tubes.used);
     for (i = 0; i < tubes.used; i++) {
         t = tubes.items[i];
-        dprintf("for %s t->waiting.used=%zu t->ready.used=%d t->pause=%" PRIu64 "\n",
+        dbgprintf("for %s t->waiting.used=%zu t->ready.used=%d t->pause=%" PRIu64 "\n",
                 t->name, t->waiting.used, t->ready.used, t->pause);
         if (t->pause) {
             if (t->deadline_at > now) continue;
@@ -395,7 +395,7 @@ next_eligible_job(usec now)
             candidate = pq_peek(&t->ready);
             if (!j || job_pri_cmp(candidate, j) < 0) j = candidate;
         }
-        dprintf("i = %zu, tubes.used = %zu\n", i, tubes.used);
+        dbgprintf("i = %zu, tubes.used = %zu\n", i, tubes.used);
     }
 
     return j;
@@ -407,9 +407,9 @@ process_queue()
     job j;
     usec now = now_usec();
 
-    dprintf("processing queue\n");
+    dbgprintf("processing queue\n");
     while ((j = next_eligible_job(now))) {
-        dprintf("got eligible job %llu in %s\n", j->id, j->tube->name);
+        dbgprintf("got eligible job %llu in %s\n", j->id, j->tube->name);
         j = pq_take(&j->tube->ready);
         ready_ct--;
         if (j->pri < URGENT_THRESHOLD) {
@@ -462,7 +462,7 @@ set_main_delay_timeout()
 
     if (j && (!deadline_at || j->deadline_at < deadline_at)) deadline_at = j->deadline_at;
 
-    dprintf("deadline_at=%" PRIu64 "\n", deadline_at);
+    dbgprintf("deadline_at=%" PRIu64 "\n", deadline_at);
     set_main_timeout(deadline_at);
 }
 
@@ -1178,7 +1178,7 @@ dispatch_cmd(conn c)
     }
 
     type = which_cmd(c);
-    dprintf("got %s command: \"%s\"\n", op_names[(int) type], c->cmd);
+    dbgprintf("got %s command: \"%s\"\n", op_names[(int) type], c->cmd);
 
     switch (type) {
     case OP_PUT:
@@ -1578,10 +1578,10 @@ h_conn_timeout(conn c)
     }
 
     if (should_timeout) {
-        dprintf("conn_waiting(%p) = %d\n", c, conn_waiting(c));
+        dbgprintf("conn_waiting(%p) = %d\n", c, conn_waiting(c));
         return reply_msg(remove_waiting_conn(c), MSG_DEADLINE_SOON);
     } else if (conn_waiting(c) && c->pending_timeout >= 0) {
-        dprintf("conn_waiting(%p) = %d\n", c, conn_waiting(c));
+        dbgprintf("conn_waiting(%p) = %d\n", c, conn_waiting(c));
         c->pending_timeout = -1;
         return reply_msg(remove_waiting_conn(c), MSG_TIMED_OUT);
     }
@@ -1773,7 +1773,7 @@ h_delay()
     for (i = 0; i < tubes.used; i++) {
         t = tubes.items[i];
 
-        dprintf("h_delay for %s t->waiting.used=%zu t->ready.used=%d t->pause=%" PRIu64 "\n",
+        dbgprintf("h_delay for %s t->waiting.used=%zu t->ready.used=%d t->pause=%" PRIu64 "\n",
                 t->name, t->waiting.used, t->ready.used, t->pause);
         if (t->pause && t->deadline_at <= now) {
             t->pause = 0;
@@ -1811,7 +1811,7 @@ h_accept(const int fd, const short which, struct event *ev)
     c = make_conn(cfd, STATE_WANTCOMMAND, default_tube, default_tube);
     if (!c) return twarnx("make_conn() failed"), close(cfd), brake();
 
-    dprintf("accepted conn, fd=%d\n", cfd);
+    dbgprintf("accepted conn, fd=%d\n", cfd);
     r = conn_set_evq(c, EV_READ | EV_PERSIST, (evh) h_conn);
     if (r == -1) return twarnx("conn_set_evq() failed"), close(cfd), brake();
 }
diff --git a/util.h b/util.h
index c6865fb..0034f1a 100644
--- a/util.h
+++ b/util.h
@@ -43,9 +43,9 @@ extern char *progname;
                                    __FILE__, __LINE__, __func__, ##args)
 
 #ifdef DEBUG
-#define dprintf(fmt, args...) ((void) fprintf(stderr, fmt, ##args))
+#define dbgprintf(fmt, args...) ((void) fprintf(stderr, fmt, ##args))
 #else
-#define dprintf(fmt, ...) ((void) 0)
+#define dbgprintf(fmt, ...) ((void) 0)
 #endif
 
 typedef uint64_t usec;

