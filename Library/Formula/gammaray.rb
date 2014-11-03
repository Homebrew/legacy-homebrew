require "formula"

class Gammaray < Formula
  homepage "http://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/archive/v2.2.0.tar.gz"
  sha1 "c6055ae24b67465528b1747f2ac291adcd805a8e"

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
    args = std_cmake_args
    args << "-DGAMMARAY_ENFORCE_QT4_BUILD=" + ((build.with? "qt4") ? "ON" : "OFF")
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=" + ((build.without? "vtk") ? "ON" : "OFF" )
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=" + ((build.without? "graphviz") ? "ON" : "OFF" )

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match /^qt/, %x[#{bin}/gammaray --list-probes].chomp
  end
end
