class Moc < Formula
  desc "Terminal-based music player"
  homepage "http://moc.daper.net"
  revision 2
  head "svn://daper.net/moc/trunk"

  stable do
    url "http://ftp.daper.net/pub/soft/moc/stable/moc-2.5.0.tar.bz2"
    sha256 "d29ea52240af76c4aa56fa293553da9d66675823e689249cee5f8a60657a6091"

    # Backport r2779: Adapt to FFmpeg/LibAV's audioconvert.h rename (commit 5980f5dd).
    # Necessary for building against FFmpeg 3.0. See http://moc.daper.net/node/1496.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/1282e60/moc/moc-2.5.0.diff"
      sha256 "1a7d2d7f967c8182db01dd95d5a05aac8f2acae2eac6fcda419baaed068bc8ef"
    end
  end

  bottle do
    sha256 "717d61c1ffe92dc06eb29d4041983fe2ef521abd3d9b97028013b8c496e02aca" => :el_capitan
    sha256 "ef91d680c58d0f949e56d209967f75737ba48c919537824d8f25233672a783c3" => :yosemite
    sha256 "39a6dc0a11c173a4e4556d7774061c12fdaf532a218ca1891ce367c453c75c31" => :mavericks
  end

  option "with-ncurses", "Build with wide character support."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "berkeley-db"
  depends_on "jack"
  depends_on "ffmpeg" => :recommended
  depends_on "mad" => :optional
  depends_on "flac" => :optional
  depends_on "speex" => :optional
  depends_on "musepack" => :optional
  depends_on "libsndfile" => :optional
  depends_on "wavpack" => :optional
  depends_on "faad2" => :optional
  depends_on "timidity" => :optional
  depends_on "libmagic" => :optional
  depends_on "homebrew/dupes/ncurses" => :optional

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
        You must start the jack daemon prior to running mocp.
        If you need wide-character support in the player, for example
        with Chinese characters, you can install using
            --with-ncurses
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mocp --version")
  end
end
