class Snappy < Formula
  homepage "http://snappy.googlecode.com"
  url "https://drive.google.com/uc?id=0B0xs9kK-b5nMOWIxWGJhMXd6aGs&export=download"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/snappy/snappy_1.1.2.orig.tar.gz"
  sha256 "f9d8fe1c85494f62dbfa3efe8e73bc23d8dec7a254ff7fe09ec4b0ebfc586af4"
  version "1.1.2"

  head do
    url "https://github.com/google/snappy.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "c95c90ea412c185d42346f21637157c82ccfd6cfee7830d3fdf7c7427cc1630f" => :yosemite
    sha256 "3237d3ca278cabb40968699b45914fd3468363cb291bfc19e45a265a68a54c28" => :mavericks
    sha256 "36ac0b1d4cb6edbe915ba54a79a600674757ce5682fa1389e4a1ef98d7c10884" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build

  def install
    ENV.universal_binary if build.universal?
    ENV.j1 if build.stable?

    if build.head?
      # https://github.com/google/snappy/pull/4
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
