class Why3 < Formula
  homepage "http://why3.lri.fr/"
  url "https://gforge.inria.fr/frs/download.php/file/34074/why3-0.85.tar.gz"
  sha1 "c8d5f56c80f936a667ea2719baa99bb84a5f05ca"

  bottle do
    sha1 "8b4e05c0ebe37dfed94a33693f5e93130a08cbd7" => :yosemite
    sha1 "2e1b210bfa283db5116bba485f0d2bc8c68aacef" => :mavericks
    sha1 "a6b08c8f3b78fd3c0bba978ef59a03dd701f85f3" => :mountain_lion
  end

  depends_on "objective-caml"
  depends_on "coq" => :optional
  depends_on "lablgtk" => :optional
  depends_on "hevea" => [:build, :optional]
  depends_on "rubber" => :build

  def install
    system "./configure", "--enable-verbose-make",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/why3", "config", "--detect", "--dont-save"
  end
end
