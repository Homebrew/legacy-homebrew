class Subnetcalc < Formula
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.2.tar.gz"
  sha256 "910ec4f47d8d3348be9ec8d66404259c0a48d2f40db86f7a71a469dd3ecf4339"

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
