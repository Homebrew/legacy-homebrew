class HttpLoad < Formula
  desc "Test throughput of a web server by running parallel fetches"
  homepage "http://www.acme.com/software/http_load/"
  url "http://www.acme.com/software/http_load/http_load-14aug2014.tar.gz"
  version "20140814"
  sha256 "538a19cf1a45b1c0ca9be2a5f421b0a3f8d1989c24657d08bc139144b6e14622"

  # HTTPS support
  depends_on "openssl" => :optional

  def install
    bin.mkpath
    man1.mkpath

    args = %W[
      BINDIR=#{bin}
      LIBDIR=#{lib}
      MANDIR=#{man1}
      CC=#{ENV.cc}
    ]

    if build.with? "openssl"
      inreplace "Makefile", "#SSL_", "SSL_"
      args << "SSL_TREE=#{Formula["openssl"].opt_prefix}"
    end

    system "make", "install", *args
  end

  test do
    (testpath/"urls").write "http://brew.sh"
    system "#{bin}/http_load", "-rate", "1", "-fetches", "1", "urls"
  end
end
