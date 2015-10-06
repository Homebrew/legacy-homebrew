class Alure < Formula
  desc "Manage common tasks with OpenAL applications"
  homepage "http://kcat.strangesoft.net/alure.html"
  url "http://kcat.strangesoft.net/alure-releases/alure-1.2.tar.bz2"
  sha256 "465e6adae68927be3a023903764662d64404e40c4c152d160e3a8838b1d70f71"

  bottle do
    cellar :any
    sha256 "271fbc61bdd430e8bc5f6624a2944bd3d0e2ffa8787f1899c3ae98b768fd229d" => :el_capitan
    sha256 "79205290fb22706d0b5d855ad4067f08dbdaf3f93274eef7e900cbe7d4fd841f" => :yosemite
    sha256 "8c388226c9c1544308895f9b8e6b5ff882e64431bfac00b342d13e045bb6e51a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "libogg" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libvorbis" => :optional
  depends_on "mpg123" => :optional

  def install
    # fix a broken include flags line, which fixes a build error.
    # Not reported upstream.
    # https://github.com/Homebrew/homebrew/pull/6368
    if build.with? "libvorbis"
      inreplace "CMakeLists.txt", "${VORBISFILE_CFLAGS}",
        `pkg-config --cflags vorbisfile`.chomp
    end

    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
