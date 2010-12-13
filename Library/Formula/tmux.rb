require 'formula'

class Tmux <Formula
  url 'http://downloads.sourceforge.net/tmux/tmux-1.3.tar.gz'
  md5 '96e60cb206de2db0610b9fb6a64c2251'
  homepage 'http://tmux.sourceforge.net'

  depends_on 'libevent'

  def patches
    # Patch originally from Macports ticket #18357
    # Committed in Macports rev 58563
    # https://trac.macports.org/changeset/58563
    { :p1 => DATA }
  end

  def install
    ENV['PREFIX'] = prefix
    system "./configure"

    inreplace "GNUmakefile" do |s|
      # Fix 'install' flags
      s.gsub! " -g bin -o root", ""
      # Put docs in the right place
      s.gsub! "man/man1", "share/man/man1"
    end

    system "make install"
  end
end

__END__
diff -Nur tmux-1.3/server.c tmux-1.3.new/server.c
--- tmux-1.3/server.c	2010-06-23 09:21:39.000000000 +1000
+++ tmux-1.3.new/server.c	2010-11-29 08:48:48.000000000 +1100
@@ -35,6 +35,8 @@
 #include <time.h>
 #include <unistd.h>

+void *_vprocmgr_detach_from_console(unsigned int flags);
+
 #include "tmux.h"

 /*
@@ -137,8 +139,8 @@
	 * Must daemonise before loading configuration as the PID changes so
	 * $TMUX would be wrong for sessions created in the config file.
	 */
-	if (daemon(1, 0) != 0)
-		fatal("daemon failed");
+	if (_vprocmgr_detach_from_console(0) != NULL)
+		fatalx("_vprocmgr_detach_from_console failed");

	/* event_init() was called in our parent, need to reinit. */
	if (event_reinit(ev_base) != 0)
