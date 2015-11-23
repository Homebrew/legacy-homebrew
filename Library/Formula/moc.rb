class Moc < Formula
  desc "Terminal-based music player"
  homepage "http://moc.daper.net"
  url "http://ftp.daper.net/pub/soft/moc/stable/moc-2.5.0.tar.bz2"
  sha256 "d29ea52240af76c4aa56fa293553da9d66675823e689249cee5f8a60657a6091"

  bottle do
    revision 1
    sha256 "3188a4355200b250e6a63c909c6ef8a7a458e25377a6a17d6f62455072b38e40" => :yosemite
    sha256 "ccfd6919a5d64861ecc66f6ad01e8b4f259295dbe3772b459bb139ab0908b2e0" => :mavericks
    sha256 "94cca91c117a1575aa61a10f288e95672e61bfe0c1d473b2fac70c480c0d92ab" => :mountain_lion
  end

  head do
    url "svn://daper.net/moc/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  option "with-ncurses", "Build with wide character support."

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
    system "autoreconf", "-fvi" if build.head?
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
end
