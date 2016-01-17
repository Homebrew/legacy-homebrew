class Libvoikko < Formula
  desc "Linguistic software for Finnish and other languages and Finnish dictionary"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.0.tar.gz"
  sha256 "24c6e3625eb5a8550512f7ad2f708c5392b9a0b164c04fb3659592048555e291"

  resource "voikko-fi" do
    url "http://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.0.tar.gz"
    sha256 "02f7595dd7e3cee188184417d6a7365f9dc653b020913f5ad75d1f14b548fafd"
  end

  bottle do
    cellar :any
    sha256 "c4488efa1bc718a9c56e3b3a98f3606810c70c999942dbaf8f7ab06005bd152e" => :yosemite
    sha256 "c8ad1b1671f4689dd0758a77a65e5a6e208fe77392d971695bab8d7ed0e27313" => :mavericks
    sha256 "e86477889e8ff1ffe9b1f60de5506e911cb584be674b6adaf5dffc58cc1c50d5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on :python3 => :build
  depends_on "foma" => :build
  depends_on "hfstospell"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", "#{bin}"
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
