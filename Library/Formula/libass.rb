class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.12.3/libass-0.12.3.tar.gz"
  sha256 "5aa6b02b00de7aa2d795e8afa77def47485fcc68a190f4326b6e4d40aee30560"

  bottle do
    cellar :any
    sha256 "5790f99bd0c16069163657ab46601c25ccb1e3586326f0914305797fbf49f1a1" => :yosemite
    sha256 "0e41667064f0c89ccec2f3e01c67bb6e5fd319bb279921a33da4c4a23eb5a541" => :mavericks
    sha256 "bf8e4ad18cc7c245db6607cd4ccdae7addebd2a267d8473c1da1b6db508c5bbf" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  depends_on "freetype"
  depends_on "fribidi"
  depends_on "fontconfig"
  depends_on "harfbuzz" => :optional

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
