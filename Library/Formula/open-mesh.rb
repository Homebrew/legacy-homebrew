require "formula"

class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "http://openmesh.org"
  url "http://www.openmesh.org/media/Releases/3.3/OpenMesh-3.3.tar.gz"
  sha1 "673677702a27a929c9124f8d4ea2b188a0500c50"

  bottle do
    cellar :any
    sha256 "e4bc6932d6a585fa96b9cc8f09c3037d852dae79072a8feea47612ba48598212" => :yosemite
    sha256 "7806df7d4f499a801350087017944a79365336aec3b266bb5bee2ef17ffa017a" => :mavericks
    sha256 "0ca60ff704a7d442bdd432d9a63f58d2e453d787648f3831bcaa27ac2f5a1114" => :mountain_lion
  end

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
