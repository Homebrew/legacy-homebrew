class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://www.bunkus.org/videotools/mkvtoolnix/"
  url "https://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-8.2.0.tar.xz"
  sha256 "eb6d3d7a0254bb4326dccc9983418801783198cdf4a259f31261dab4e843a5c4"

  bottle do
    sha256 "875fa8eaa7db4432055e76fe736f7729a434b9205b76749316f6553171ef2d9a" => :yosemite
    sha256 "0f1078ea8ede5db65be4e1d6786b6fea947b6e480be8f21f5fa36842a094ef2d" => :mavericks
    sha256 "fff1c5b4d95a964e6af8eabd4d4eb79f07e86bbb6e66ba5e5eda7209a79112fb" => :mountain_lion
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
