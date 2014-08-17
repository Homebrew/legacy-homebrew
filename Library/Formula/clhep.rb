require "formula"

class Clhep < Formula
  homepage "http://proj-clhep.web.cern.ch/proj-clhep/"
  url "http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.2.0.1.tgz"
  sha1 "88b9d4f39be3ac317e63c2f7ad694ede6e7b7520"

  bottle do
    cellar :any
    sha1 "f5f803b03710e3acf529eab111428570e536ebb6" => :mavericks
    sha1 "610b51552b3864eb26c75b2d242d43c81187d770" => :mountain_lion
    sha1 "36b000d7ecf82b8c528b1bd2a02d58c39beab1bf" => :lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "clhep-build" do
      system "cmake", "../CLHEP", *std_cmake_args
      system "make install"
    end
  end
end
