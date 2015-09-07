class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.3.0/gammaray-2.3.0.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gammaray/gammaray_2.3.0.orig.tar.gz"
  sha256 "d3da28ff1f7ac5534e518a9d4a7b5d7d22267490d3ab3ae094b0592d33244799"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha1 "07bfe7c133e5a72e116f07b5cd65e70b6e5ee00b" => :yosemite
    sha1 "7d1e58d5d6c9212c52445859921554c22f0f4404" => :mavericks
    sha1 "8f1aa69e5a27f6078f3fe5c3c5b67f6caa931f55" => :mountain_lion
  end

  option "without-qt4", "Build against Qt5 instead of Qt4 (default)"
  option "with-vtk", "Build with VTK-with-Qt support, for object 3D visualizer"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "qt" if build.with? "qt4"
  depends_on "qt5" if build.without? "qt4"
  depends_on "graphviz" => :recommended

  # VTK needs to have Qt support, and it needs to match GammaRay's
  depends_on "homebrew/science/vtk" => [:optional, ((build.with? "qt4") ? "with-qt" : "with-qt5")]

  def install
    # For Mountain Lion
    ENV.libcxx

    args = std_cmake_args
    args << "-DGAMMARAY_ENFORCE_QT4_BUILD=" + ((build.with? "qt4") ? "ON" : "OFF")
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=" + ((build.without? "vtk") ? "ON" : "OFF")
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=" + ((build.without? "graphviz") ? "ON" : "OFF")

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (prefix/"GammaRay.app/Contents/MacOS/GammaRay").executable?
  end
end
