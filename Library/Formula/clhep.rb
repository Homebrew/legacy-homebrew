class Clhep < Formula
  homepage "http://proj-clhep.web.cern.ch/proj-clhep/"
  url "http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.2.0.4.tgz"
  sha1 "60a291b940fdc78bea4aaeaffc147cc25a42cfef"

  bottle do
    cellar :any
    sha1 "af98835b134fefc9532141ad6b9999542de25413" => :mavericks
    sha1 "6d45d414a3036c932a2e0a3dd5bc0ba22ff53315" => :mountain_lion
    sha1 "549425101a1b93753d567e5eb6d2f8a202179559" => :lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "clhep-build" do
      system "cmake", "../CLHEP", *std_cmake_args
      system "make", "install"
    end
  end
end
