class Mkvtoolnix < Formula
  homepage "https://www.bunkus.org/videotools/mkvtoolnix/"
  url "https://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-7.7.0.tar.xz"
  sha256 "191d8892b8fb36ac492c710134d419d7578ba802e812a32eb90ae02d4b13c028"

  bottle do
    sha1 "c0aa6d1f587159dfcf89f0f193c1fc97ae8554da" => :yosemite
    sha1 "022ff93c8ee34b6958ccbcba2aa96e82e8b5410e" => :mavericks
    sha1 "1ded8d87b52b495e9a94e0cfab5e4623532ff98a" => :mountain_lion
  end

  head do
    url "https://github.com/mbunkus/mkvtoolnix.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-wxmac", "Build with wxWidgets GUI"
  option "with-qt5", "Build with experimental QT GUI"

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
      args << "--enable-gui" << "--enable-wxwidgets"
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
