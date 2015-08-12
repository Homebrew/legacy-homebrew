class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "http://www.wavpack.com/"
  url "http://www.wavpack.com/wavpack-4.75.2.tar.bz2"
  sha256 "7d31b34166c33c3109b45c6e4579b472fd05e3ee8ec6d728352961c5cdd1d6b0"

  bottle do
    cellar :any
    sha256 "2558e5df140a20b53ed4b8022844803f7f3c31902ea484d1b0fa5817f93342b4" => :el_capitan
    sha256 "62bbb3a5c1c0f30e8b121791d58c67c55bf43f88aa4b68b3cbd53739abad1491" => :yosemite
    sha256 "fd1a0d8e4de7612abc11f1f84620290f2606e0797872a368bda943bc065b3d44" => :mavericks
  end

  head do
    url "https://github.com/dbry/WavPack.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

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
