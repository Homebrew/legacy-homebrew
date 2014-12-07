require "formula"

class Ruby19 < Requirement
  fatal true
  default_formula "ruby"

  satisfy :build_env => false do
    next unless which "ruby"
    version = /\d\.\d/.match `ruby --version 2>&1`
    next unless version
    Version.new(version.to_s) >= Version.new("1.9")
  end

  def modify_build_environment
    ruby = which "ruby"
    return unless ruby
    ENV.prepend_path "PATH", ruby.dirname
  end

  def message; <<-EOS.undent
    The mkvtoolnix buildsystem needs Ruby >=1.9
    EOS
  end
end

class Mkvtoolnix < Formula
  homepage "https://www.bunkus.org/videotools/mkvtoolnix/"
  url "https://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-7.3.0.tar.xz"
  sha1 "c5379fa684a0a5e6cf0db7404b72e7075989a1a3"

  bottle do
    sha1 "56cde38aad413ef85cdea858e4609abc4fc70491" => :yosemite
    sha1 "06dc3b91062deb677a95b9eb416232ff6c5e319c" => :mavericks
    sha1 "db880af7a75c5979aed0c1f19e02c63e0d17e7c7" => :mountain_lion
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
  depends_on Ruby19
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "expat"
  depends_on "pcre"
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
