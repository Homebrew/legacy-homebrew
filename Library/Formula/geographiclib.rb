class Geographiclib < Formula
  desc "C++ geography library"
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.46.tar.gz"
  sha256 "3a0606fd99fb099572ba1923f556b05b545965359edb92930a658fc99172d962"

  bottle do
    cellar :any
    sha256 "a0fcfdfb1de30b9fa7f06880d361da5cda5f69cbe71195d40cd7365275a22099" => :el_capitan
    sha256 "ae55c9b959d4288af4034bac7217a76d21d643a64f4ec4ce91ff640abb5ae86c" => :yosemite
    sha256 "987c4d54b285eb8ed0051ae422a32b152a74bd3becbd84a9e673858e1322809c" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
