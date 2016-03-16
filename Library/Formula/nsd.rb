class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.9.tar.gz"
  sha256 "b811224d635331de741f1723aefc41adda0a0a3a499ec310aa01dd3b4b95c8f2"

  bottle do
    sha256 "ca1cc7f3b4558f4d9be7027a1c68d1c36b7e3b354202cf6de65143de659557e8" => :el_capitan
    sha256 "dbf1cdbb15aa49181dacce1169b06bbce05b9d2b83baf676ca8892a76e13455f" => :yosemite
    sha256 "09f97c4518e697a27191f38950716b17dca0a34ec00b502498aa28493bf716bc" => :mavericks
  end

  option "with-root-server", "Allow NSD to run as a root name server"
  option "with-bind8-stats", "Enable BIND8-like NSTATS & XSTATS"
  option "with-ratelimit", "Enable rate limiting"
  option "with-zone-stats", "Enable per-zone statistics"

  depends_on "libevent"
  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
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
