class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.13.0/libass-0.13.0.tar.gz"
  sha256 "67692ef2a56e0423d22b142edb072c04949fe88c37be1d19cf22669c44f935f3"

  bottle do
    cellar :any
    sha256 "66953583bba73a4432c773e4a40bf8155e73ba05e14c7d78e07480e99df2ddbf" => :el_capitan
    sha256 "5790f99bd0c16069163657ab46601c25ccb1e3586326f0914305797fbf49f1a1" => :yosemite
    sha256 "0e41667064f0c89ccec2f3e01c67bb6e5fd319bb279921a33da4c4a23eb5a541" => :mavericks
    sha256 "bf8e4ad18cc7c245db6607cd4ccdae7addebd2a267d8473c1da1b6db508c5bbf" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz" => :recommended

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
