class Honeyd < Formula
  desc "Daemon to create virtual hosts simulating their services and behaviour"
  homepage "http://honeyd.org/"
  url "http://www.honeyd.org/uploads/honeyd-1.5c.tar.gz"
  sha256 "3186d542085b7b4b67d168ee0eb872c2c46dd3e98846a775c9f196e94c80916d"

  depends_on "libdnet"

  # Requires libevent1, not 2 - http://libevent.org/
  resource "libevent1" do
    url "https://github.com/downloads/libevent/libevent/libevent-1.4.14b-stable.tar.gz"
    sha256 "afa61b476a222ba43fc7cca2d24849ab0bbd940124400cb699915d3c60e46301"
  end

  # make the setrlimit function work
  # honeyd is no longer developed so patching upstream won't happen
  patch :DATA

  def install
    libevent1_prefix = libexec/"libevent1"

    resource("libevent1").stage do
      system "./configure", "--prefix=#{libevent1_prefix}"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-libevent=#{libevent1_prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/honeyd.c b/honeyd.c
index d6dd8e6..bfff951 100644
--- a/honeyd.c
+++ b/honeyd.c
@@ -450,7 +450,7 @@ honeyd_init(void)

	/* Raising file descriptor limits */
	rl.rlim_max = RLIM_INFINITY;
-	rl.rlim_cur = RLIM_INFINITY;
+	rl.rlim_cur = OPEN_MAX;
	if (setrlimit(RLIMIT_NOFILE, &rl) == -1) {
		/* Linux does not seem to like this */
		if (getrlimit(RLIMIT_NOFILE, &rl) == -1)
