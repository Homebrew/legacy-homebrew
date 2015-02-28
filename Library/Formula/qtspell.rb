class Qtspell < Formula
  homepage "https://github.com/manisandro/qtspell"
  url "https://github.com/manisandro/qtspell/releases/download/0.7.1/qtspell-0.7.1.tar.xz"
  sha1 "7e959b8147192818fa56824bf39d4384b0242032"

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "enchant"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end
end
