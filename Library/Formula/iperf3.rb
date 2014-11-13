require "formula"

class Iperf3 < Formula
  homepage "https://github.com/esnet/iperf"

  stable do
    url "https://github.com/esnet/iperf/archive/3.0.9.tar.gz"
    sha256 "985d87e2bc3f302dd5e864022f61b053cdeafd2e6a325711a317ed6aa1b68771"

    # Fix Compile errors for Yosemite - https://github.com/esnet/iperf/issues/213
    patch do
      url "https://github.com/esnet/iperf/commit/cc4a7fa75d94.diff"
      sha1 "6792c1a0cfddb2249d4ae2a3e202cd652b70b729"
    end
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  bottle do
    cellar :any
    revision 1
    sha1 "5184a6130741de7784072465f36337b8a9846ce0" => :yosemite
    sha1 "f9ca4f7cf295338dde6f69f960f5e09446da3d3b" => :mavericks
    sha1 "6f29512d493e596bf1ef3a0e125e7dc7b030de35" => :mountain_lion
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
