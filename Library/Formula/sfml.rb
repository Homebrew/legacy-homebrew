require "formula"

class Sfml < Formula
  homepage "http://www.sfml-dev.org/"

  stable do
    url "http://www.sfml-dev.org/download/sfml/2.1/SFML-2.1-sources.zip"
    sha1 "c27bdffdc4bedb5f6a20db03ceca715d42aa5752"

    # Too many upstream differences to fix Yosemite compile.
    # Big code changes upstream since previous release 15 months ago.
    # Please remove this block with the next stable release.
    depends_on MaximumMacOSRequirement => :mavericks
  end

  bottle do
    cellar :any
    sha1 "5c2ddfbbc587914a6c9b4f02831e607a398753e7" => :mavericks
    sha1 "2be6977ed7c225032825ed4f521e9883d4cb5db1" => :mountain_lion
    sha1 "ad6f666a6a23ddf5eab12a58f4c6dd0b8e6b777b" => :lion
  end

  head "https://github.com/LaurentGomila/SFML.git"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "jpeg"
  depends_on "libsndfile"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_FRAMEWORK_PREFIX=#{frameworks}/", *std_cmake_args
    system "make", "install"
  end
end
