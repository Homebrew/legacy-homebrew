class Normalize < Formula
  desc "Adjust volume of audio files to a standard level"
  homepage "http://normalize.nongnu.org/"
  url "http://download.savannah.nongnu.org/releases/normalize/normalize-0.7.7.tar.gz"
  sha256 "6055a2abccc64296e1c38f9652f2056d3a3c096538e164b8b9526e10b486b3d8"

  bottle do
    cellar :any
    sha256 "b4775cffb28a34356c69082b09f2dad8e4014107c392e598420f04905874ce88" => :el_capitan
    sha256 "2b9032f1d711dae164305017b9154f3f3cf307195825d9c279e4ac8212a1f5b8" => :yosemite
    sha256 "6231c50a60cd4ebf510f879df8d8b537f79914d8f844b48896b5659965f7919d" => :mavericks
  end

  option "without-mad", "Compile without MP3 support"

  depends_on "mad" => :recommended

  conflicts_with "num-utils", :because => "both install `normalize` binaries"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]
    args << "--without-mad" if build.without? "mad"

    system "./configure", *args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system "#{bin}/normalize", "test.mp3"
  end
end
