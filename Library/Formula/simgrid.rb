class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "http://gforge.inria.fr/frs/download.php/file/33686/SimGrid-3.11.1.tar.gz"
  sha256 "7796ef6d4288462fdabdf5696c453ea6aabc433a813a384db2950ae26eff7956"

  bottle do
    cellar :any
    sha1 "880b9462dcea8f3f9c4aa4c32e507ef8e7155db5" => :mavericks
    sha1 "bbaba0f593b4b81f1e1ebd604dc46eaa58ec8568" => :mountain_lion
    sha1 "7f1cdc6fd8de1a046b15cbc3b8a648e8ccb5775f" => :lion
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
