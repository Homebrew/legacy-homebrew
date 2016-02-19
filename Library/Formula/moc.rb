class Moc < Formula
  desc "Terminal-based music player"
  homepage "http://moc.daper.net"
  revision 1
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
    sha256 "b3d43cf6d54e7eb20f8fbc07972cac29d07981b368fc634a5fd1589785a938d8" => :el_capitan
    sha256 "a357e2bf5d82609c5ed97d90eec43f7652b9a8d549e277bcd00d84268581f97d" => :yosemite
    sha256 "5659197b36c9ec6af7daf9dc10c3990ce166e00ab7c200e43ba7caeb9641e07d" => :mavericks
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
