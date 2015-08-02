class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://www.bunkus.org/videotools/mkvtoolnix/"

  stable do
    url "https://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-8.2.0.tar.xz"
    sha256 "eb6d3d7a0254bb4326dccc9983418801783198cdf4a259f31261dab4e843a5c4"

    # Fix GUI builds when "--without-curl" is passed, which we do by default.
    patch do
      url "https://github.com/mbunkus/mkvtoolnix/commit/5c56d6544ffc212ca39ac59f4ed98b4f04761de8.diff"
      sha256 "52f0ee02111c85bf6381d86ccf6a5333f8a89aa717235e7f0f919d3f686af2fc"
    end
  end

  bottle do
    revision 1
    sha256 "de910b676dad60fcbe058bb16fa23110b047c9d65478fc62c15264708cff09f3" => :yosemite
    sha256 "596783853470024d56b855868b824238599449e52bb919aeede56ebab296bd27" => :mavericks
    sha256 "c5652c2e926937cb17b520e5aefc9b2bf2533af43a38c268568e4366c80cb126" => :mountain_lion
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
  depends_on :ruby => "1.9"
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

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --without-curl
      --with-boost=#{boost.opt_prefix}
    ]

    if build.with? "wxmac"
      wxmac = Formula["wxmac"]
      args << "--with-extra-includes=#{ogg.opt_include};#{vorbis.opt_include};#{wxmac.opt_include}"
      args << "--with-extra-libs=#{ogg.opt_lib};#{vorbis.opt_lib};#{wxmac.opt_lib}"
      args << "--enable-wxwidgets"
    else
      args << "--with-extra-includes=#{ogg.opt_include};#{vorbis.opt_include}"
      args << "--with-extra-libs=#{ogg.opt_lib};#{vorbis.opt_lib}"
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
