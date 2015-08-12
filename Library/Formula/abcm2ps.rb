class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "http://moinejf.free.fr/abcm2ps-8.11.0.tar.gz"
  sha256 "c57a32cb188f632be7febe53f48ad659df2a66d7d152687d21b1e41c37d49431"

  bottle do
    sha256 "7878c909878ebf4d13f390be4e9a3e3d0a9ddf4ffa8d796e825ad842f350a875" => :el_capitan
    sha256 "8fff2718b8841e1efffbf9ac111c03bba00dba9f45b58a883dd0e9fc2f9f2e19" => :yosemite
    sha256 "4abbf22b95f5e5562ee2473069b4df0ce52d27a4dc9603ba757df007e3e0456e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "pango" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"voices.abc").write <<-EOF.undent
      X:7
      T:Qui Tolis (Trio)
      C:Andre Raison
      M:3/4
      L:1/4
      Q:1/4=92
      %%staves {(Pos1 Pos2) Trompette}
      K:F
      %
      V:Pos1
      %%MIDI program 78
      "Positif"x3 |x3|c'>ba|Pga/g/f|:g2a |ba2 |g2c- |c2P=B  |c>de  |fga |
      V:Pos2
      %%MIDI program 78
              Mf>ed|cd/c/B|PA2d |ef/e/d |:e2f |ef2 |c>BA |GA/G/F |E>FG |ABc- |
      V:Trompette
      %%MIDI program 56
      "Trompette"z3|z3 |z3 |z3 |:Mc>BA|PGA/G/F|PE>EF|PEF/E/D|C>CPB,|A,G,F,-|
    EOF

    system "#{bin}/abcm2ps", testpath/"voices"
    assert File.exist?("Out.ps")
  end
end
