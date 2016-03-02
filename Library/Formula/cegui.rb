class Cegui < Formula
  desc "provides windowing and widget toolkits for GL and other APIs"
  homepage "http://cegui.org.uk/"
  url "https://bitbucket.org/cegui/cegui/get/v0-8-4.tar.gz"
  version "0.8.4"
  sha256 "a435a170e3ca6cca4a32ce369e12d803757264dd0d064935d7b9b4f69c8832a8"

  head do
    url "https://bitbucket.org/cegui/cegui", :using => :hg, :branch => "v0-8"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "glew"
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "pcre"

  def install
    # TODO: Enable fribidi after build problems are fixed
    args = std_cmake_args
    args << "-DCEGUI_SAMPLES_ENABLED=0"
    args << "-DCEGUI_BUILD_DATAFILE_TESTS=1"
    args << "-DCEGUI_USE_FRIBIDI=0"
    args << "-DCEGUI_BUILD_RENDERER_OPENGL3=1"
    args << "-DCEGUI_BUILD_PYTHON_MODULES=0"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    testpath = "#{prefix}/cegui/build"
    system "CEGUI_SAMPLE_DATAPATH=`pwd`/../datafiles", "ctest", "-V"
  end
end
