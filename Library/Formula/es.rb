require "formula"

class Es < Formula
  homepage "http://wryun.github.io/es-shell/"
  url "https://github.com/downloads/wryun/es-shell/es-0.9.tar.gz"
  sha1 "40b0b3838c07a434b4cccca9a8bb173c71eda7d8"

  option 'with-readline', 'Use readline instead of libedit'

  depends_on 'readline' => :optional

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-readline" if build.with? 'readline'
    system "./configure", *args
    system "make"

    man1.install 'doc/es.1'
    bin.install 'es'
    doc.install %w{CHANGES README trip.es examples}
  end

  test do
    system "#{bin}/es < #{doc}/trip.es"
  end
end
