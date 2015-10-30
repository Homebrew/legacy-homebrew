class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://www.bunkus.org/videotools/mkvtoolnix/"
  url "https://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-8.5.1.tar.xz"
  sha256 "db9ae151ef236afac190c0137d8d4df4e43c105dbd298e3913b5afae1fdd5b43"

  bottle do
    sha256 "a636ec0b5d4951d972eaa4b6696bbd94843fd68765cb8bdab53b3793f5a6b4a8" => :el_capitan
    sha256 "d33130834424f3f2b347ee0104d8396a3239184a142151e3df15d86c754541ec" => :yosemite
    sha256 "896c637b08ea859563a793cdb5629389e320334ca747bb0d56b555f6b3e83689" => :mavericks
  end

  head do
    url "https://github.com/mbunkus/mkvtoolnix.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-wxmac", "Build with wxWidgets GUI"
  option "with-qt5", "Build with QT GUI"

  depends_on "pkg-config" => :build
  depends_on :ruby => ["1.9", :build]
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "flac" => :recommended
  depends_on "libmagic" => :recommended
  depends_on "lzo" => :optional
  depends_on "wxmac" => :optional
  depends_on "qt5" => :optional
  depends_on "gettext" => :optional

  # On Mavericks, the bottle (without c++11) can be used
  # because mkvtoolnix is linked against libc++ by default
  if MacOS.version >= "10.9"
    depends_on "boost"
    depends_on "libmatroska"
    depends_on "libebml"
  else
    depends_on "boost" => "c++11"
    depends_on "libmatroska" => "c++11"
    depends_on "libebml" => "c++11"
  end

  needs :cxx11

  def install
    ENV.cxx11

    boost = Formula["boost"]
    ogg = Formula["libogg"]
    vorbis = Formula["libvorbis"]
    ebml = Formula["libebml"]
    matroska = Formula["libmatroska"]

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --without-curl
      --with-boost=#{boost.opt_prefix}
    ]

    if build.with? "wxmac"
      wxmac = Formula["wxmac"]
      args << "--with-extra-includes=#{ogg.opt_include};#{vorbis.opt_include};#{ebml.opt_include};#{matroska.opt_include};#{wxmac.opt_include}"
      args << "--with-extra-libs=#{ogg.opt_lib};#{vorbis.opt_lib};#{ebml.opt_lib};#{matroska.opt_lib};#{wxmac.opt_lib}"
      args << "--enable-wxwidgets"
    else
      args << "--with-extra-includes=#{ogg.opt_include};#{vorbis.opt_include};#{ebml.opt_include};#{matroska.opt_include}"
      args << "--with-extra-libs=#{ogg.opt_lib};#{vorbis.opt_lib};#{ebml.opt_lib};#{matroska.opt_lib}"
      args << "--disable-wxwidgets"
    end

    if build.with?("qt5")
      qt5 = Formula["qt5"]

      args << "--with-moc=#{qt5.opt_bin}/moc"
      args << "--with-uic=#{qt5.opt_bin}/uic"
      args << "--with-rcc=#{qt5.opt_bin}/rcc"
      args << "--with-mkvtoolnix-gui"
      args << "--enable-qt"
    else
      args << "--disable-qt"
    end

    system "./autogen.sh" if build.head?

    system "./configure", *args

    system "./drake", "-j#{ENV.make_jobs}"
    system "./drake", "install"
  end

  test do
    mkv_path = testpath/"Great.Movie.mkv"
    sub_path = testpath/"subtitles.srt"
    sub_path.write <<-EOS.undent
      1
      00:00:10,500 --> 00:00:13,000
      Homebrew
    EOS

    system "#{bin}/mkvmerge", "-o", mkv_path, sub_path
    system "#{bin}/mkvinfo", mkv_path
    system "#{bin}/mkvextract", "tracks", mkv_path, "0:#{sub_path}"
  end
end
