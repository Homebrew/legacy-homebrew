class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.2.tar.gz"
  sha256 "910ec4f47d8d3348be9ec8d66404259c0a48d2f40db86f7a71a469dd3ecf4339"

  bottle do
    cellar :any
    sha256 "02fd178c7ff46ec328cd0df18bd4b6dfa02eff644e0e39c40058747b9e9ddc48" => :yosemite
    sha256 "d715440781a9204d3d3d6ed08b7c6f1b0e68c5e8b757b1e650730b19c32a57cc" => :mavericks
    sha256 "1d643a3fe2fce8b5227cafa6d570d1bf158c0c05171a7b2eef15559802bd46fd" => :mountain_lion
  end

  head do
    url "https://github.com/dreibh/subnetcalc.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "geoip" => :recommended

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    args << "--with-geoip=no" if build.without? "geoip"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system "#{bin}/subnetcalc", "::1"
  end
end
