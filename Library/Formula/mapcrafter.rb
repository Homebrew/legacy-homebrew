require "formula"

class Mapcrafter < Formula
  homepage "http://mapcrafter.org/"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.1.5.3.tar.gz"
  version "1.5.3"
  sha1 "0568f6adf5aca4fc367c31fc06f6c1130d351ab3"

  head 'https://github.com/mapcrafter/mapcrafter.git'

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpng"
  depends_on "libjpeg-turbo"
  
  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    cmake_args = std_cmake_args
    cmake_args << "-DJPEG_INCLUDE_DIR=/usr/local/opt/jpeg-turbo/include/"
    cmake_args << "-DJPEG_LIBRARY=/usr/local/opt/jpeg-turbo/lib/libjpeg.dylib"
    
    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make install"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test mapcrafter`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
