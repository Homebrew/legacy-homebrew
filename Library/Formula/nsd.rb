class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.3.tar.gz"
  sha256 "097cb295cdd3e8a73a8afac343caf0fca11b72b2214b022689ddc423312d17e5"

  bottle do
    sha256 "502aa5481346dec1c0d4b93ea52124b4a1048da77e6f3e35b7e5511d4160e190" => :yosemite
    sha256 "2259c260c9adc42effab728f8482db424a18c7706d059f47f11c10898b3f45bb" => :mavericks
    sha256 "774de8fc2c45a20ea33088183a0d8ab120eddbc87bdf6a43fa0f974458ad163b" => :mountain_lion
  end

  option "with-root-server", "Allow NSD to run as a root name server"
  option "with-bind8-stats", "Enable BIND8-like NSTATS & XSTATS"
  option "with-ratelimit", "Enable rate limiting"
  option "with-zone-stats", "Enable per-zone statistics"

  depends_on "libevent"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-libevent=#{Formula["libevent"].opt_prefix}
    ]

    args << "--enable-root-server" if build.with? "root-server"
    args << "--enable-bind8-stats" if build.with? "bind8-stats"
    args << "--enable-ratelimit" if build.with? "ratelimit"
    args << "--enable-zone-stats" if build.with? "zone-stats"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
