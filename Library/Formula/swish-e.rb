class SwishE < Formula
  homepage "http://swish-e.org/"
  url "http://swish-e.org/distribution/swish-e-2.4.7.tar.gz"
  sha256 "5ddd541ff8ecb3c78ad6ca76c79e620f457fac9f7d0721ad87e9fa22fe997962"

  depends_on "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"swish-e", "-S", "fs", "-i", *Dir[HOMEBREW_PREFIX/"*.md"]
    output = shell_output("#{bin}/swish-e -w respect")
    assert_match /^# Number of hits: [1-9]\d*$/, output
  end
end
