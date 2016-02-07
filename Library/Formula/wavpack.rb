class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "http://www.wavpack.com/"

  stable do
    url "http://www.wavpack.com/wavpack-4.75.2.tar.bz2"
    sha256 "7d31b34166c33c3109b45c6e4579b472fd05e3ee8ec6d728352961c5cdd1d6b0"
  end

  bottle do
    cellar :any
    revision 1
    sha256 "eab7743515c92a2f9259d5582e41a368b358a27354d5183a6c78d00b3b2dcb96" => :yosemite
    sha256 "b96fa889976f26fd0ae30eb492aa7817d59bd0a5a24586e8a20fc18d5b029646" => :mavericks
    sha256 "a0a1437a79256fa2a2d94391ff433921a9acb7ab50c7018a170be8a0c9d1295d" => :mountain_lion
  end

  head do
    url "https://github.com/dbry/WavPack.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking"
    ]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"wavpack", test_fixtures("test.wav"), "-o", testpath/"test.wv"
    File.exist? "test.wv"
  end
end
