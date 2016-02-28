class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord/"
  url "https://download.drobilla.net/sord-0.14.0.tar.bz2"
  sha256 "7656d8ec56a43e0f0a168fe78670a7628a42d3a597b53c7a72ac243a74e0f19a"

  bottle do
    cellar :any
    sha256 "113bba5f6c7b78525e2b5939e49bcf97e4970dc0434627767a6f05e3813462a2" => :el_capitan
    sha256 "c1f1d50de1da970b37e2a5c10eaa359aff6353e3f733646120ede97a604fa99f" => :yosemite
    sha256 "1106f91a4f435adc5c05a4a3c39ae8cc0b10be207acc8915c6979dd9227bb42b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "serd"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
