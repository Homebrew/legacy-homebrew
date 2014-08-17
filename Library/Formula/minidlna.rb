require "formula"

class Minidlna < Formula
  homepage "http://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.1.3/minidlna-1.1.3.tar.gz"
  sha1 "3e5b907fd35b667eb50af98e1f986c7f461a6042"

  depends_on "libav"
  depends_on "libexif"
  depends_on "jpeg"
  depends_on "libid3tag"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"
  depends_on "ffmpeg"

  patch do
    url "http://sourceforge.net/p/minidlna/patches/104/attachment/0001-Remove-check-for-getifaddr-returning-IFF_SLAVE-if-IF.patch"
    sha1 "768b119a59c803af4d074138b70b245aa72e426f"
  end

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
