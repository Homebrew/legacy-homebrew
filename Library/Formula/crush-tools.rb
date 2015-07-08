class CrushTools < Formula
  desc "Command-line tools for processing delimited text data"
  homepage "https://github.com/google/crush-tools/"
  url "https://github.com/google/crush-tools/archive/2013-04.tar.gz"
  version "2013-04"
  sha256 "55b80440b5892ec9ac9b812c72a615bc8455d4928540e75baf2513fb14ad358a"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  conflicts_with "aggregate", :because => "both install an `aggregate` binary"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
