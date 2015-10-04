class Es < Formula
  desc "Extensible shell with first class functions, lexical scoping, and more"
  homepage "https://wryun.github.io/es-shell/"
  url "https://github.com/downloads/wryun/es-shell/es-0.9.tar.gz"
  sha256 "c4ab446642284924449c3d0a90c678fa7891aacd429ffdb3744899c44a298cfb"

  option "with-readline", "Use readline instead of libedit"

  depends_on "readline" => :optional

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-readline" if build.with? "readline"
    system "./configure", *args
    system "make"

    man1.install "doc/es.1"
    bin.install "es"
    doc.install %w[CHANGES README trip.es examples]
  end

  test do
    system "#{bin}/es < #{doc}/trip.es"
  end
end
