class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "http://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.1.5/minidlna-1.1.5.tar.gz"
  sha256 "8477ad0416bb2af5cd8da6dde6c07ffe1a413492b7fe40a362bc8587be15ab9b"

  bottle do
    cellar :any
    sha256 "20b87cf651499f92c73a5e22823eaa268f37611c61e8f74f7f43e508c3e140ab" => :el_capitan
    sha256 "a03b5be50423b59805acb5e268c75bbd1f5685ae4a0e35f87a556d7a3ee7c2fc" => :yosemite
    sha256 "6f8bb8023f20b7e3131320f14f3bc042d2d1077dd100ec089a2c65d08f2279e3" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/minidlna/git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gettext" => :build
  end

  depends_on "libexif"
  depends_on "jpeg"
  depends_on "libid3tag"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"
  depends_on "ffmpeg"

  def install
    ENV.append_to_cflags "-std=gnu89"
    system "./autogen.sh" if build.head?
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
    media_dir=#{ENV["HOME"]}/.config/minidlna/media
    db_dir=#{ENV["HOME"]}/.config/minidlna/cache
    log_dir=#{ENV["HOME"]}/.config/minidlna
    EOS
  end

  test do
    system "#{sbin}/minidlnad", "-V"
  end
end
