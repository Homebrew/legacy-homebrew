class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://sourceforge.net/projects/libwbxml/"
  url "https://downloads.sourceforge.net/project/libwbxml/libwbxml/0.11.4/libwbxml-0.11.4.tar.bz2"
  sha256 "8057998042b8a724328346a50c326010ba011a40e18e2df7043e87498a679c28"
  head "https://github.com/libwbxml/libwbxml.git"

  bottle do
    cellar :any
    sha256 "8dea99c05944dcc9b28a3494d00ff32d136669c6bb49ad3eb6640f7a2601f879" => :el_capitan
    sha256 "3a3c54f55e3ca674f6e8cc993519b3988d174a642ad25bcbf3e540e35d541d90" => :yosemite
    sha256 "cc821ee98e3af666012edf1abfbce6cf1816e3609a1fcf679519c2f883a84000" => :mavericks
  end

  option "with-docs", "Build the documentation with Doxygen and Graphviz"
  deprecated_option "docs" => "with-docs"

  depends_on "cmake" => :build
  depends_on "wget" => :optional

  if build.with? "docs"
    depends_on "doxygen" => :build
    depends_on "graphviz" => :build
  end

  def install
    # Sandbox fix:
    # Install in Cellar & then automatically symlink into top-level Module path.
    inreplace "cmake/CMakeLists.txt", "${CMAKE_ROOT}/Modules/", "#{share}/cmake/Modules"

    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_DOCUMENTATION=ON" if build.with? "docs"
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
