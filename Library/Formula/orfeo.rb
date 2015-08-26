class Orfeo < Formula
  desc "Library of image processing algorithms"
  homepage "https://www.orfeo-toolbox.org/"
  url "https://downloads.sourceforge.net/project/orfeo-toolbox/OTB/OTB-5.0.0/OTB-5.0.0.tgz"
  sha256 "35e2f1d280f4a33b3d38af840a83069b34b2ea99acba18b1a944acccdbf1a976"

  option "with-examples", "Compile and install various examples"
  option "with-java", "Enable Java support"
  option "with-patented", "Enable patented algorithms"

  deprecated_option "examples" => "with-examples"
  deprecated_option "java" => "with-java"
  deprecated_option "patented" => "with-patented"

  depends_on "cmake" => :build
  depends_on :python => :optional
  depends_on "homebrew/science/insighttoolkit"
  depends_on "homebrew/science/vtk"
  depends_on "fltk"
  depends_on "gdal"
  depends_on "qt"
  depends_on "tinyxml"

  def install
    args = std_cmake_args + %W[
      -DBUILD_APPLICATIONS=ON
      -DOTB_USE_EXTERNAL_FLTK=ON
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
      -DOTB_WRAP_QT=ON
    ]

    args << "-DBUILD_EXAMPLES=" + ((build.include? "examples") ? "ON" : "OFF")
    args << "-DOTB_WRAP_JAVA=" + ((build.include? "java") ? "ON" : "OFF")
    args << "-DOTB_USE_PATENTED=" + ((build.include? "patented") ? "ON" : "OFF")
    args << "-DOTB_WRAP_PYTHON=OFF" if build.without? "python"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end
end
