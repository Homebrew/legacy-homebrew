class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "http://www.wavpack.com/"

  stable do
    url "http://www.wavpack.com/wavpack-4.75.0.tar.bz2"
    sha256 "c63e5c2106749dc6b2fb4302f2260f4803a93dd6cadf337764920dc836e3af2e"

    patch do
      url "https://github.com/dbry/WavPack/commit/12867b33e2de3e95b88d7cb6f449ce0c5c87cdd5.diff"
      sha256 "a6e010e3a50697811db42860ee4af1190ef4c098f65738d21890c2fb2d57f282"
    end
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
      "--disable-dependency-tracking",
      # https://github.com/dbry/WavPack/issues/3
      "--disable-asm"
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
