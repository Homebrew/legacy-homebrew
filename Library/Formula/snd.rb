require "formula"

class Snd < Formula
  homepage "https://ccrma.stanford.edu/software/snd/"
  url "ftp://ccrma-ftp.stanford.edu/pub/Lisp/snd-14.7.tar.gz"
  sha1 "14433e0baa87305f783a98fa2161374dfe3a915f"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "portaudio"
  depends_on "gtk+"
  depends_on "fftw"

  def install
    system "ruby tools/make-config-pc.rb > ./ruby.pc"
    ENV["PKG_CONFIG_PATH"] += ":."
    system "./configure", "--with-gtk",
                          "--with-ruby",
                          "--with-portaudio",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/snd", "--help"
  end

end
