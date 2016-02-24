class Cabocha < Formula
  desc "Yet Another Japanese Dependency Structure Analyzer"
  homepage "https://taku910.github.io/cabocha/"
  url "https://googledrive.com/host/0B4y35FiV1wh7cGRCUUJHVTNJRnM/cabocha-0.69.tar.bz2"
  sha256 "9db896d7f9d83fc3ae34908b788ae514ae19531eb89052e25f061232f6165992"

  bottle do
    sha256 "bf3ed6bc9333b43919264913c40a86997a7601a83abf6dcfa1dfe14745b3fc7c" => :el_capitan
    sha256 "fe97decdca655899faffd6356bb8ddbb52d4949222690835374c3aeb9a65cdb2" => :yosemite
    sha256 "794df46e362f3146b2bab17ba132978609954b0ba0a51ffa4d6d4e8845548764" => :mavericks
    sha256 "b1aaf6623ac7332459c795ebd992ed92224b0d0b9e20fb57dd0313fbeea7647c" => :mountain_lion
  end

  option "with-charset=", "choose default charset: EUC-JP, CP932, UTF8"
  option "with-posset=", "choose default posset: IPA, JUMAN, UNIDIC"

  deprecated_option "charset=" => "with-charset="
  deprecated_option "posset=" => "with-posset="

  depends_on "crf++"
  depends_on "mecab"

  # To see which dictionaries are available, run:
  #     ls `mecab-config --libs-only-L`/mecab/dic/
  depends_on "mecab-ipadic" => :recommended
  depends_on "mecab-jumandic" => :optional
  depends_on "mecab-unidic" => :optional

  def install
    ENV["LIBS"] = "-liconv"

    inreplace "Makefile.in" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "CXXFLAGS", ENV.cflags
    end

    charset = ARGV.value("with-charset") || "UTF8"
    posset = ARGV.value("with-posset") || "IPA"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=#{charset}
      --with-posset=#{posset}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    result = `echo "CaboCha はフリーソフトウェアです。" | cabocha | md5`.chomp
    assert_equal "a5b8293e6ebcb3246c54ecd66d6e18ee", result
  end
end
