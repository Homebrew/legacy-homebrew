class Libvoikko < Formula
  desc "Linguistic software and and Finnish dictionary"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.0.1.tar.gz"
  sha256 "4fdc12dec38c0e074f0728652b8bc52595e3d63b2c8c87e8a05cd55b808d32a1"

  bottle do
    cellar :any
    sha256 "d745301863983935bb7b6f1d9b2746c38f0aeda97e5d120f62bbd45bc901a3cc" => :el_capitan
    sha256 "3c9bdcd0170d3d76b4cd920264b4af7bd85fba39620caaf88bcdfc0303f051ee" => :yosemite
    sha256 "ece41b8c399cb5f068284ae19fa9bbccd1feef049cb517d3aa5f8dc4dfc22284" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on :python3 => :build
  depends_on "foma" => :build
  depends_on "hfstospell"

  needs :cxx11

  resource "voikko-fi" do
    url "http://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.0.tar.gz"
    sha256 "02f7595dd7e3cee188184417d6a7365f9dc653b020913f5ad75d1f14b548fafd"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
