class Orfeo < Formula
  desc "Library of image processing algorithms"
  homepage "http://www.orfeo-toolbox.org/otb/"
  url "https://downloads.sourceforge.net/project/orfeo-toolbox/OTB/OTB-5.0.0/OTB-5.0.0.tgz"
  sha256 "35e2f1d280f4a33b3d38af840a83069b34b2ea99acba18b1a944acccdbf1a976"

  option "with-examples", "Compile and install various examples"
  option "with-java", "Enable Java support"

  deprecated_option "examples" => "with-examples"

  depends_on "cmake" => :build
  depends_on :python => :optional
  depends_on "gdal"
  depends_on "libgeotiff"
  depends_on "fftw"
  depends_on "open-scene-graph" => ["with-gdal"]
  depends_on "homebrew/science/insighttoolkit"
  depends_on "homebrew/science/vtk"
  depends_on "tinyxml"
  depends_on "ossim"

  def install
    mkdir "build" do
      args = "-DCMAKE_BUILD_TYPE=Release"
      args << "-DBUILD_EXAMPLES=" + ((build.with? "examples") ? "ON" : "OFF")
      args << "-DOTB_WRAP_JAVA=" + ((build.with? "java") ? "ON" : "OFF")
      args << "-DOTB_WRAP_PYTHON=OFF" if build.without? "python"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"HelloWorldOTB.cxx").write <<-EOS
      #include "otbImage.h" 
      #include <iostream> 
       
      int main() 
      { 
        typedef otb::Image<unsigned short, 2> ImageType; 
       
        ImageType::Pointer image = ImageType::New(); 
       
        std::cout << "OTB Hello World !" << std::endl; 
       
        return EXIT_SUCCESS;
      }    
    EOS
    (testpath/"CmakeLists.txt").write <<-EOS
      cmake_minimum_required(VERSION 2.6)  
      FIND_PACKAGE(OTB)  
      INCLUDE(${OTB_USE_FILE})  
      ADD_EXECUTABLE(HelloWorldOTB HelloWorldOTB.cxx )  
      TARGET_LINK_LIBRARIES(HelloWorldOTB ${OTB_LIBRARIES})
    EOS
    system "cmake" , "."
    system "make"
    system "./HelloWorldOTB"
  end
end
