class Mediatomb < Formula
  desc "Open source (GPL) UPnP MediaServer"
  homepage "http://mediatomb.cc"
  url "https://downloads.sourceforge.net/mediatomb/mediatomb-0.12.1.tar.gz"
  sha256 "31163c34a7b9d1c9735181737cb31306f29f1f2a0335fb4f53ecccf8f62f11cd"
  revision 2

  bottle do
    revision 2
    sha256 "9657cf88850ab7800c0c16c842d100fa0f4348bffa2d1622c3286d34aca28346" => :el_capitan
    sha256 "94b23a7e9ae0b4b027fb239cfa5200169b0afcb4a3016340c25c04d0c0704150" => :yosemite
    sha256 "4343242a9b034835bd8053065f6f1243b6c089c9393e30845dcaac188a271ed5" => :mavericks
  end

  depends_on "libexif" => :recommended
  depends_on "libmagic" => :recommended
  depends_on "lzlib" => :recommended
  depends_on "mp4v2" => :recommended
  depends_on "spidermonkey" => :recommended
  depends_on "sqlite" => :recommended
  depends_on "taglib" => :recommended

  depends_on "ffmpeg" => :optional
  depends_on "ffmpegthumbnailer" => :optional
  depends_on "id3lib" => :optional
  depends_on "lastfmlib" => :optional
  depends_on "mysql" => :optional

  # This is for libav 0.7 support. See:
  # https://bugs.launchpad.net/ubuntu/+source/mediatomb/+bug/784431
  # http://sourceforge.net/tracker/?func=detail&aid=3291062&group_id=129766&atid=715780
  patch do
    url "https://launchpadlibrarian.net/71985647/libav_0.7_support.patch"
    sha256 "c6523e8bf5e2da89b7475d6777ef9bffe7d089752ef2f7b27b5e39a4130fb0ff"
  end

  patch do
    url "https://ftp.heanet.ie/mirrors/fink/finkinfo/10.7/stable/main/finkinfo/net/mediatomb.patch"
    sha256 "7e8ef3e1bec9a045549b468a3441f9d3d7bb42a7e77564a5fedea2d6024303ea"
  end

  patch do
    url "https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/net-misc/mediatomb/files/mediatomb-0.12.1-libav9.patch"
    sha256 "ae07427380e22f7340af28ea8d8d4bd01ec07f1c09bd0e0e50f310b2b4e507e2"
  end

  patch do
    url "https://sourceforge.net/p/mediatomb/patches/_discuss/thread/57c47fb9/8ad8/attachment/mediatomb-urifix.patch"
    sha256 "537373654c1d7fa24e14f2e5a9c78228589411509d46fbd53bb38b87d5ee34fb"
  end

  # Upstream patch: http://sourceforge.net/p/mediatomb/patches/35/
  patch do
    url "https://gist.githubusercontent.com/jacknagel/0971b2626b3a3c86c055/raw/31e568792918b57622dba559658e4161ad87f519/0010_fix_libmp4v2_build.patch"
    sha256 "8823da463d22c74b0a87a0054e1594e2fb8d418eff93b86e346e5506bb5a7323"
  end

  # Calling "include <new>" doesn't seem to make size_t available here.
  # Submitted upstream: https://sourceforge.net/p/mediatomb/patches/46
  # Seems to be related to this sort of error:
  # https://stackoverflow.com/questions/5909636/overloading-operator-new
  patch do
    url "https://sourceforge.net/p/mediatomb/patches/46/attachment/object.diff"
    sha256 "b289e77a5177aa66da45bdb50e5f04c94fb1b8d14c83faa72251ccae8680a1d3"
  end

  # FreeBSD patch to fix Clang compile.
  # https://svnweb.freebsd.org/ports/head/net/mediatomb/files/patch-timer.cc?revision=397755&view=markup
  # Noted here with the GCC patch: https://sourceforge.net/p/mediatomb/patches/46/#54bc
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/d316eac2/mediatomb/timercc.diff"
    sha256 "e1ea57ca4b855b78c70de1e5041ecfa46521a19bd95d2594efe7e6f69014baca"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-libmp4v2" if build.without? "mp4v2"

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Edit the config file ~/.mediatomb/config.xml before running mediatomb.
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/mediatomb --ip 127.0.0.1 --port 49153"
    end
    sleep 2

    begin
      assert_match /file is part of MediaTomb/, shell_output("curl 127.0.0.1:49153")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
