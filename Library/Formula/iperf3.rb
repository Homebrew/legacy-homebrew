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
    sha1 "ae7e7fedcd9eca4b6e6696d49178126918fae84e" => :yosemite
    sha1 "34430a2a0bd66ac4bb06fa2dbecabcfff95cf532" => :mavericks
    sha1 "cf2950226718253c8c647f416c0c1f2df6fddd11" => :mountain_lion
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
