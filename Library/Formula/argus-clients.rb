class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "http://qosient.com/argus/"
  url "http://qosient.com/argus/src/argus-clients-3.0.8.tar.gz"
  sha256 "aee8585d50959e00070a382f3121edfaa844a0a51dc0b73edf84c0f4eb8912c9"

  bottle do
    cellar :any
    sha256 "77e408f35d3ac39f64ecd55ed0ad5c331257321c1083bc2ee7aaff2c0e083b16" => :el_capitan
    sha256 "6c021bea57676fed8b2f58a243c1453bee760435c6feaf41b487b35777fdfea4" => :yosemite
    sha256 "35a73804fe589cacdf5f7ac315c686b0d7e5e4bbfff13dc96d427f1dbe125928" => :mavericks
    sha256 "c820b241451f2b98d6757cfc752bf023d358c776f77a6ba15f476b21f36191f5" => :mountain_lion
  end

  depends_on "readline" => :recommended
  depends_on "rrdtool" => :recommended

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
