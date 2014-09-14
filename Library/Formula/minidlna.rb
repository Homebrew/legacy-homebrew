require "formula"

class Minidlna < Formula
  homepage "http://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.1.4/minidlna-1.1.4.tar.gz"
  sha1 "56f333f8af91105ce5f0861d1f1918ebf5b0a028"

  depends_on "libav"
  depends_on "libexif"
  depends_on "jpeg"
  depends_on "libid3tag"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"
  depends_on "ffmpeg"

  # Remove check for getifaddr returning IFF_SLAVE if IFF_SLAVE is not defined
  # (which it is not on OS X)
  patch :DATA

  def install
    ENV.append_to_cflags "-std=gnu89"
    system "./configure", "--exec-prefix=#{prefix}"
    system "make", "install"
    sample_config_path.write sample_config
  end

  def caveats; <<-EOS.undent
      Simple single-user configuration:

      mkdir -p ~/.config/minidlna
      cp #{sample_config_path} ~/.config/minidlna/minidlna.conf
      ln -s YOUR_MEDIA_DIR ~/.config/minidlna/media
      minidlnad -f ~/.config/minidlna/minidlna.conf -P ~/.config/minidlna/minidlna.pid
    EOS
  end

  def sample_config_path
    share + "minidlna/minidlna.conf"
  end

  def sample_config; <<-EOS.undent
    friendly_name=Mac DLNA Server
    media_dir=#{ENV['HOME']}/.config/minidlna/media
    db_dir=#{ENV['HOME']}/.config/minidlna/cache
    log_dir=#{ENV['HOME']}/.config/minidlna
    EOS
  end

  test do
    system "#{sbin}/minidlnad", "-V"
  end
end

__END__
diff --git a/getifaddr.c b/getifaddr.c
index 329a96b..0de0afb 100644
--- a/getifaddr.c
+++ b/getifaddr.c
@@ -86,8 +86,12 @@ getifaddr(const char *ifname)
 		if (ifname && strcmp(p->ifa_name, ifname) != 0)
 			continue;
 		addr_in = (struct sockaddr_in *)p->ifa_addr;
-		if (!ifname && (p->ifa_flags & (IFF_LOOPBACK | IFF_SLAVE)))
+		if (!ifname && (p->ifa_flags & IFF_LOOPBACK))
 			continue;
+#ifdef IFF_SLAVE
+		if (!ifname && (p->ifa_flags & IFF_SLAVE))
+			continue;
+#endif
 		memcpy(&lan_addr[n_lan_addr].addr, &addr_in->sin_addr, sizeof(lan_addr[n_lan_addr].addr));
 		if (!inet_ntop(AF_INET, &addr_in->sin_addr, lan_addr[n_lan_addr].str, sizeof(lan_addr[0].str)) )
 		{
