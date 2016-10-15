require "formula"

class Stormlib < Formula
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "http://www.zezula.net/download/stormlib-9.00.zip"
  sha1 "d1c4f458c0f7a87843c983cf2823cfcea45f3cec"
  head "https://github.com/stormlib/StormLib.git"

  depends_on "cmake" => :build

  def install
    inreplace "CMakeLists.txt" do |s|
      s.gsub! /\/Library\/Frameworks/, "lib/"
    end
    system "cmake", ".", *std_cmake_args
    system "make install"
    lib.install_symlink lib/'storm.framework' => 'storm.framework'
  end

end
