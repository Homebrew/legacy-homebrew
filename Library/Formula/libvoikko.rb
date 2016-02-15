class Libvoikko < Formula
  desc "Linguistic software and and Finnish dictionary"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.0.1.tar.gz"
  sha256 "4fdc12dec38c0e074f0728652b8bc52595e3d63b2c8c87e8a05cd55b808d32a1"

  bottle do
    cellar :any
    sha256 "d22047d2e96418f4f00a23dc8be15f597791d2afe73707584eb06e9482f3f83a" => :el_capitan
    sha256 "9f8ada3163060f6fe71adf9849fbd019fd1f8b1d26d0770abc7267b706342965" => :yosemite
    sha256 "f0dce2aef19383349b4fac06db0cb6f75cce8122d6279e65925103caf5fd3158" => :mavericks
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
