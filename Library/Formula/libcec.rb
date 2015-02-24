class Libcec < Formula
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-2.2.0-repack.tar.gz"
  sha1 "42e19328c5b05b5fff27bcdf80e7acc329201913"

  bottle do
    cellar :any
    sha1 "d80df26b65e04fdc1a4a6ba2801e54231d9b7be7" => :yosemite
    sha1 "9344093a4180a7f5d0e066ba4b50f301fd1e80b1" => :mavericks
    sha1 "5b04eb4b157c34ab543082a9c9c0868450412c37" => :mountain_lion
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
