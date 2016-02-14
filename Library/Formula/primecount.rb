class Primecount < Formula
  desc "Fast C++ program for counting primes"
  homepage "https://github.com/kimwalisch/primecount"
  url "http://dl.bintray.com/kimwalisch/primecount/primecount-2.6.tar.gz"
  version "2.6"
  sha256 "ab5790e1fef22b21d50748795b1502d18e969fa9b1cd443305b08534c96430ec"

  # Always build from source for maximum performance.
  # Enables OpenMP multi-threading if the compiler supports it
  # and uses the POPCNT instruction if the CPU supports it.
  bottle :disable, "Library and clients must be built on the same microarchitecture"

  depends_on "primesieve"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/primecount", "1e15", "--status"
  end
end
