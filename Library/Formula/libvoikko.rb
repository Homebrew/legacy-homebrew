class Libvoikko < Formula
  desc "Linguistic software and and Finnish dictionary"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.0.2.tar.gz"
  sha256 "0bfaaabd039024920713020671daff828434fcf4c89bce4601b94a377567f2a3"

  # Standard compatibility fixes for Clang, upstream pull request at
  # https://github.com/voikko/corevoikko/pull/22
  patch :p2 do
    url "https://github.com/voikko/corevoikko/commit/f69bab4.diff"
    sha256 "415fc284feccb3b55972177d73d32a445a4c9b790071637d8d64da9c86ab2928"
  end

  bottle do
    cellar :any
    sha256 "2eb82a48b1859e90f72cb932def86f46437b68c06237f7bc03a3c62a512da73a" => :el_capitan
    sha256 "951b89e8c6e372b8a950f646eba4a3dc0cfff6f0fa0939507baecdaa82afda4a" => :yosemite
    sha256 "7584eb257d6e626a16bf9e562dc96bb801c23074ec8741f350ab3801093f893d" => :mavericks
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
