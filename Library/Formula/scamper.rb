class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20141211c.tar.gz"
  sha256 "303ca5c408604acc54759a922050094f24bcfc7fe6c7cedf5aea95b59792c1ad"

  depends_on "openssl" if MacOS.version < :el_capitan

  bottle do
    cellar :any
    sha256 "47399b4eff1888cc2c15a10f43c814218fc0567cf007ecd01d355be1f3ef08e5" => :el_capitan
    sha256 "f2062ee005e32ae802a79ab5282a07bc695b813628a7fbf15deb2c6afc21db92" => :yosemite
    sha256 "3193ff3d026504bea4a41102e5afe67fc10c3739db039833aa0872f0b85ee2c7" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
