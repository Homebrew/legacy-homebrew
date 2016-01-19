class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"

  stable do
    url "https://github.com/esnet/iperf/archive/3.0.11.tar.gz"
    sha256 "c774b807ea4db20e07558c47951df186b6fb1dd0cdef4282c078853ad87cc712"
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  bottle do
    cellar :any
    sha256 "451060a5b7811824a29b1814dfb33fdcf89836cc277f9eff675510d6fd9bc458" => :el_capitan
    sha256 "023bc1d684749db3cc8a2584d1c92c15c691b5afed13eb4ae94c98c25cefe6a1" => :yosemite
    sha256 "8a461d45d6e5a9bca5778f174cd48445c3bf5659ceb017e6bc82ba0fb289a15c" => :mavericks
    sha256 "391b1e77cf0805e7fab56c14a6fa5e8aa832ad43da77f320e5150c4b69547f5c" => :mountain_lion
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "clean"      # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    system "#{bin}/iperf3", "--version"
  end
end
