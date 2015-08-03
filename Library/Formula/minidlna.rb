class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "http://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.1.4/minidlna-1.1.4.tar.gz"
  sha256 "9814c04a2c506a0dd942c4218d30c07dedf90dabffbdef2d308a3f9f23545314"
  revision 2

  bottle do
    cellar :any
    sha256 "8f9e4ee18d746731d37330c3b04b729235d16b49567a6980a3f7d76e37fe444a" => :yosemite
    sha256 "d42575d92f63cfc68bff7d4fcf68b6aa4738490f66f016625099eed627e803b7" => :mavericks
    sha256 "ed8cb39eed82926932beed72e00d6c96e22eabfe39f4296f5345079da78813d5" => :mountain_lion
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
