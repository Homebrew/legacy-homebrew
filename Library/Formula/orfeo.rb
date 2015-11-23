class Orfeo < Formula
  desc "Library of image processing algorithms"
  homepage "http://www.orfeo-toolbox.org/otb/"
  url "https://downloads.sourceforge.net/project/orfeo-toolbox/OTB/OTB-3.20/OTB-3.20.0.tgz"
  sha256 "7c405756887842fbdfd6eb99a1fdc3c940817290a99c188414e5af45702d1b9d"

  depends_on "cmake" => :build
  depends_on :python => :optional
  depends_on "fltk"
  depends_on "gdal"
  depends_on "qt"

  option "examples", "Compile and install various examples"
  option "java", "Enable Java support"
  option "patented", "Enable patented algorithms"

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
