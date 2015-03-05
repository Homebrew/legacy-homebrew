class Telegram < Formula
  homepage "https://github.com/vysheng/tg"
  url "https://github.com/vysheng/tg/archive/1.0.5.1.tar.gz"
  sha1 "72f6a9f89ee9db90b573bad25e567a2015115848"

  depends_on "openssl"
  depends_on "libevent"
  depends_on "libconfig"
  depends_on "readline"
  depends_on "lua"

  patch :DATA

  def install
    ENV.append "CFLAGS", "-I#{Formula["readline"].prefix}/include"
    ENV.append "LDFLAGS", "-L#{Formula["readline"].prefix}/lib"

    system "./configure", "--prefix=#{prefix}"
    system "make"

    bin.install "bin/telegram-cli"
    etc.install "tg-server.pub"
  end

  test do
    (testpath/'tg.txt').write <<-EOS.undent
      #
      not a phone number
      #
    EOS
    `#{bin}/telegram-cli < tg.txt 2 >&1`
  end
end

__END__
diff --git a/main.c b/main.c
index ff57ec1..b1d314d 100644
--- a/main.c
+++ b/main.c
@@ -804,6 +804,7 @@ int main (int argc, char **argv) {
   parse_config ();

   tgl_set_rsa_key ("/etc/" PROG_NAME "/server.pub");
+  tgl_set_rsa_key ("HOMEBREW_PREFIX/etc/tg-server.pub");
   tgl_set_rsa_key ("tg-server.pub");
