class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.1.5/minidlna-1.1.5.tar.gz"
  sha256 "8477ad0416bb2af5cd8da6dde6c07ffe1a413492b7fe40a362bc8587be15ab9b"
  revision 1

  bottle do
    cellar :any
    sha256 "26eca84ae424d6c09eaaafed4c1086f5f0a0b7ac31d85f5b2326ac79fc4f2d13" => :el_capitan
    sha256 "5f60b419cbaaafe10346bee031fe8ade57776e40833846164280950595d7a601" => :yosemite
    sha256 "6685427a0ff92f85a312e6b378ed3aa3ce746b0777bd661dbc544883261fa19a" => :mavericks
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
  end

  def post_install
    (pkgshare/"minidlna.conf").write <<-EOS.undent
      friendly_name=Mac DLNA Server
      media_dir=#{ENV["HOME"]}/.config/minidlna/media
      db_dir=#{ENV["HOME"]}/.config/minidlna/cache
      log_dir=#{ENV["HOME"]}/.config/minidlna
    EOS
  end

  def caveats; <<-EOS.undent
      Simple single-user configuration:

      mkdir -p ~/.config/minidlna
      cp #{opt_pkgshare}/minidlna.conf ~/.config/minidlna/minidlna.conf
      ln -s YOUR_MEDIA_DIR ~/.config/minidlna/media
      minidlnad -f ~/.config/minidlna/minidlna.conf -P ~/.config/minidlna/minidlna.pid
    EOS
  end

  test do
    (testpath/".config/minidlna/media").mkpath
    (testpath/".config/minidlna/cache").mkpath
    (testpath/"minidlna.conf").write <<-EOS.undent
      friendly_name=Mac DLNA Server
      media_dir=#{testpath}/.config/minidlna/media
      db_dir=#{testpath}/.config/minidlna/cache
      log_dir=#{testpath}/.config/minidlna
    EOS

    pid = fork do
      exec "#{sbin}/minidlnad -f minidlna.conf -p 8081 -P #{testpath}/minidlna.pid"
    end
    sleep 2

    begin
      assert_match /MiniDLNA #{version}/, shell_output("curl localhost:8081")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
