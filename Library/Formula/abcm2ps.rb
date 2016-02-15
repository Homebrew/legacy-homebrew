class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "http://moinejf.free.fr/abcm2ps-8.11.0.tar.gz"
  sha256 "c57a32cb188f632be7febe53f48ad659df2a66d7d152687d21b1e41c37d49431"

  bottle do
    sha256 "3f3cbc0a52593625dd5d14cfc4678f92dcfcbf13a88bb3f51d8dd2544137b396" => :yosemite
    sha256 "11dc20c7dc6bc5e71df0cc7df303df3027de9663f3c7cdc1425151b8007081dc" => :mavericks
    sha256 "904a9114ad88c9482bc8c3b7d9366ce3f2bde2e3ee324da54f9c5e70932d6c7e" => :mountain_lion
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
