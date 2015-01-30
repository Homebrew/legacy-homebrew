class Why3 < Formula
  homepage "http://why3.lri.fr/"
  url "https://gforge.inria.fr/frs/download.php/file/34074/why3-0.85.tar.gz"
  sha1 "c8d5f56c80f936a667ea2719baa99bb84a5f05ca"

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
