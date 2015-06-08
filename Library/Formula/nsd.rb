class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.2.tar.gz"
  sha256 "8514b75bb8884526a637e1666911f429e0f52c5a3b0186104bb111371993644d"

  bottle do
    sha256 "5a701fff58af6bc2792766dd25e9ce339fcf17602613d312987adb08e409bc4a" => :yosemite
    sha256 "b4575e298187f6d5367b97084c6ece2b49e9b64a3d23799625bc5b939d17d288" => :mavericks
    sha256 "dfa3813fa3193e85d854f9f6d63a606d4c568c709ef499041d57f63e37551b56" => :mountain_lion
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
