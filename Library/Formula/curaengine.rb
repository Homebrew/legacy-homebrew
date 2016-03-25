class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/15.04.tar.gz"
  sha256 "d577e409b3e9554e7d2b886227dbbac6c9525efe34df4fc7d62e9474a2d7f965"

  head "https://github.com/Ultimaker/CuraEngine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ff512abcab846bd63db5a6bfb11b544c416284b46d978cd7db854879e5421d9" => :el_capitan
    sha256 "eef2771a72371fd9d541d83cf5ba92c88f1ab614017e03860f59bfacaa5eb948" => :yosemite
    sha256 "4cfea42552a3acb1ec939d882ef38bfd766a15f0f462f595e6da5f6d851a0437" => :mavericks
    sha256 "6ada916641459b6d059985c82d61a197a92bf724e7d5770a0bbcf60b6d6361a3" => :mountain_lion
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
