require "formula"

class OpenMesh < Formula
  homepage "http://openmesh.org"
  url "http://www.openmesh.org/media/Releases/3.3/OpenMesh-3.3.tar.gz"
  sha1 "673677702a27a929c9124f8d4ea2b188a0500c50"

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
