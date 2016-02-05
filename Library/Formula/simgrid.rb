class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/33686/SimGrid-3.11.1.tar.gz"
  sha256 "7796ef6d4288462fdabdf5696c453ea6aabc433a813a384db2950ae26eff7956"

  bottle do
    cellar :any
    sha256 "8ba35b7d81ce31495edce912ecdfc603a4be684c03c384b38a36f1b8ffb604e0" => :mavericks
    sha256 "e72c2f8824f8d0a457a848d0611f309f2cfd150f48e608baee7075c920e9cfb5" => :mountain_lion
    sha256 "65311d5c64c2253a33c9a0c4c703b1eab6c8554c7833ef933c8fd5cb7f36230e" => :lion
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "pcre"
  depends_on "graphviz"

  def install
    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    *std_cmake_args
    system "make", "install"
  end
end
