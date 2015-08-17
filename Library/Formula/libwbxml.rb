class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://libwbxml.opensync.org/"
  url "https://downloads.sourceforge.net/project/libwbxml/libwbxml/0.11.2/libwbxml-0.11.2.tar.bz2"
  sha256 "5f642027ece0225d80ef21979a57cf59b1027d46cb8dbd5ff4b87662eec2557d"

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
    mkdir "build" do
      args = std_cmake_args + %w[..]
      args << "-DBUILD_DOCUMENTATION=ON" if build.with? "docs"
      system "cmake", *args
      system "make", "install"
    end
  end
end
