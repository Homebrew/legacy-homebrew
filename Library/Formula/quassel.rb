class Quassel < Formula
  desc "Distributed IRC client (Qt-based)"
  homepage "http://www.quassel-irc.org/"
  head "https://github.com/quassel/quassel.git"

  stable do
    url "http://www.quassel-irc.org/pub/quassel-0.12.2.tar.bz2"
    sha256 "6bd6f79ecb88fb857bea7e89c767a3bd0f413ff01bae9298dd2e563478947897"

    # Fix Qt 5.5 build failure.
    patch do
      url "https://github.com/quassel/quassel/commit/078477395aaec1edee90922037ebc8a36b072d90.patch"
      sha256 "85adfbe4613688d0f282deb5250fb39f7534d9e6ac7450cf035cca7bbcb25cda"
    end
  end

  bottle do
    cellar :any
    sha256 "f7774d699f282e21bbeb5173ac12882d27b987e91c2852ade0956863bc66bc57" => :el_capitan
    sha256 "3363d8178acaab991193707112d25f6550b448d8035b46bb84c966be33a63ac2" => :yosemite
    sha256 "9d62b09f40bd0e3ec28c1d473c35cc07fff37127f126105cfdebcdd5e4c7fca4" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  # Official binary packages upstream now built against qt5 by default. But source
  # packages default to qt4 *for now*, and Homebrew prioritises qt5 in PATH due to keg_only.
  depends_on "qt5" => :optional
  depends_on "qt" => :recommended

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "."
    args << "-DUSE_QT5=ON" if build.with? "qt5"

    system "cmake", *args
    system "make", "install"
  end

  test do
    assert_match /Quassel IRC/, shell_output("#{bin}/quasselcore -v", 1)
  end
end
