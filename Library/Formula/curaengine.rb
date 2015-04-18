class Curaengine < Formula
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/15.04.tar.gz"
  sha256 "d577e409b3e9554e7d2b886227dbbac6c9525efe34df4fc7d62e9474a2d7f965"

  head "https://github.com/Ultimaker/CuraEngine.git"

  bottle do
    cellar :any
    sha1 "5181149b63d2d62e515cb8fdebdf331dbbfc64c0" => :yosemite
    sha1 "2fa9eb0f56c238d7cf8279c64f0215a321f846e6" => :mavericks
    sha1 "cdc1b2ceaa41b6e71ed541e5f2d85936c4d08aa3" => :mountain_lion
  end

  def install
    system "make", "VERSION=#{version}"
    bin.install "build/CuraEngine"
  end

  test do
    (testpath/"t.stl").write <<-EOF.undent
      solid t
        facet normal 0 -1 0
         outer loop
          vertex 0.83404 0 0.694596
          vertex 0.36904 0 1.5
          vertex 1.78814e-006 0 0.75
         endloop
        endfacet
      endsolid Star
    EOF

    system "#{bin}/CuraEngine", "#{testpath}/t.stl"
  end
end
