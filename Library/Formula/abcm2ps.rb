require "formula"

class Abcm2ps < Formula
  homepage "http://moinejf.free.fr"
  url "http://moinejf.free.fr/abcm2ps-7.8.11.tar.gz"
  sha1 "93e016cf933d88d817be76bd3eb4163851f3b132"

  bottle do
    sha1 "553e4b09045b5693a06faf5e202336ec5a87a9c2" => :mavericks
    sha1 "829e8538a7766248b37c7e6ad83703eda97289fa" => :mountain_lion
    sha1 "36219f8fa08cd14e376fc5e8b3a4f1627d8470da" => :lion
  end

  devel do
    url "http://moinejf.free.fr/abcm2ps-8.3.4.tar.gz"
    sha1 "e3a92e89eb55d36e582e3529846f17c60dfb788b"
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
      C:André Raison
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

    system "#{bin}/abcm2ps", (testpath/"voices")
  end
end
