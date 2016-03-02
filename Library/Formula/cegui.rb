class Cegui < Formula
  desc " provides windowing and widget toolkits for GL and other APIs"
  homepage "http://cegui.org.uk/"
  url "https://bitbucket.org/cegui/cegui/get/v0-8-4.tar.gz"
  version "0.8.5"
  sha256 "a435a170e3ca6cca4a32ce369e12d803757264dd0d064935d7b9b4f69c8832a8"

  head do
    url "https://bitbucket.org/cegui/cegui", :using => :hg, :branch => "v0-8"
  end

  # TODO: Try python option again when CEGUI issue #1114 is resolved
  #       https://bitbucket.org/cegui/cegui/issues/1114/
  #       requires boost-python also
  # option "with-python", "Build python bindings also, needed for certain apps"

  depends_on "cmake" => :build
  depends_on "glm" => :build
  # In 0.8.5 we should switch from GLEW to libepoxy, or, make an option
  depends_on "glew"
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "pcre"
  depends_on "expat" if OS.linux?

  def install
    mkdir "build"
    cd "build"

    # TODO: Enable fribidi after build problems are fixed
    cegui_opts = %w[-DCEGUI_SAMPLES_ENABLED=0 -DCEGUI_USE_FRIBIDI=0 -DCEGUI_BUILD_DATAFILE_TESTS=1]
    cegui_opts << "-DCEGUI_BUILD_DATAFILE_TESTS=1"
    cegui_opts << "-DCEGUI_BUILD_RENDERER_OPENGL3=1"

    if build.with? "python"
      cegui_opts << '-DBOOST_ROOT=#{Formula["boost"].opt_prefix}'
      cegui_opts << "-DBoost_DEBUG=1"
      cegui_opts << "-DBoost_DETAILED_FAILURE_MSG=1"
      cegui_opts << "-DCEGUI_BUILD_PYTHON_MODULES=1"
    else
      cegui_opts << "-DCEGUI_BUILD_PYTHON_MODULES=0"
    end

    system "cmake", "..", *std_cmake_args, *cegui_opts

    system "make"
    system "make", "install"
  end

  test do
    cd "#{prefix}/cegui/build"
    system "CEGUI_SAMPLE_DATAPATH=`pwd`/../datafiles", "ctest", "-V"
  end
end
