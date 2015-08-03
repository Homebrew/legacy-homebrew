class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "http://proj-clhep.web.cern.ch/proj-clhep/"
  url "http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.2.0.4.tgz"
  sha256 "9bf7fcd9892313c8d1436bc4a4a285a016c4f8e81e1fc65bdf6783207ae57550"

  bottle do
    cellar :any
    sha1 "5466fbee57b366a41bbcec814614ee236e39bed8" => :yosemite
    sha1 "bde270764522e4a1d99767ca759574a99485e5ac" => :mavericks
    sha1 "e77d0e5f516cb41ac061e1050c8f37d0fb65b796" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "clhep-build" do
      system "cmake", "../CLHEP", *std_cmake_args
      system "make", "install"
    end
  end
end
