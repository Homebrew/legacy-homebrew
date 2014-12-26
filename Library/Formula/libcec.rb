class Libcec < Formula
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-2.2.0-repack.tar.gz"
  sha1 "42e19328c5b05b5fff27bcdf80e7acc329201913"

  bottle do
    cellar :any
    sha1 "15c6c1b20a5d4847017d0d0a1f02c3519080a236" => :yosemite
    sha1 "26a55716130e364641b6eec32e56ad41b7a7e7a3" => :mavericks
    sha1 "34efc22ee55549ddee07ffc17f3647b8fe180399" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cec-client", "--info"
  end
end
