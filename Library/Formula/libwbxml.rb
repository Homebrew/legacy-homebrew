class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://sourceforge.net/projects/libwbxml/"
  url "https://downloads.sourceforge.net/project/libwbxml/libwbxml/0.11.4/libwbxml-0.11.4.tar.bz2"
  sha256 "8057998042b8a724328346a50c326010ba011a40e18e2df7043e87498a679c28"
  head "https://github.com/libwbxml/libwbxml.git"

  bottle do
    cellar :any
    revision 1
    sha1 "15b0e5a41fad5114daf23f702893b347829ae885" => :yosemite
    sha1 "2e9d6fe9a6b9147b612350c4f12c59319bb71f5a" => :mavericks
    sha1 "3aced5392e10b5bad5e53e579a99b0247157cc42" => :mountain_lion
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
