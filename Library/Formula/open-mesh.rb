require "formula"

class OpenMesh < Formula
  homepage "http://openmesh.org"
  url "http://www.openmesh.org/media/Releases/3.1/OpenMesh-3.1.tar.gz"
  sha1 "f73fc5a072b11028b882ce1c221602040fb23be2"

  head "http://openmesh.org/svnrepo/OpenMesh/trunk/", :using => :svn

  depends_on "cmake" => :build
  depends_on "qt"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end

  test do
    system "#{bin}/mconvert", "-help"
  end
end
