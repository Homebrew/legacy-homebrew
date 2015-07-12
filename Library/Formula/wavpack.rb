class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "http://www.wavpack.com/"

  stable do
    url "http://www.wavpack.com/wavpack-4.75.0.tar.bz2"
    sha256 "c63e5c2106749dc6b2fb4302f2260f4803a93dd6cadf337764920dc836e3af2e"

    # All four patches can be removed with next stable release
    # see https://github.com/dbry/WavPack/issues/3
    patch do
      url "https://github.com/dbry/WavPack/commit/c7a0de1e5c0a91e0c458edf72e7007c386b38491.diff"
      sha256 "dc2456471ebc0adbd735628d8af7b9214e84c93d01242b6c4b747549642a7d40"
    end

    patch do
      url "https://github.com/dbry/WavPack/commit/12867b33e2de3e95b88d7cb6f449ce0c5c87cdd5.diff"
      sha256 "a6e010e3a50697811db42860ee4af1190ef4c098f65738d21890c2fb2d57f282"
    end

    patch do
      url "https://github.com/dbry/WavPack/commit/f9014956deb132463db2195633120e87a5fcb8b9.diff"
      sha256 "6736617744df2bada20148ec0525d3cb516022db699dcff4b39fb59ceac4bacf"
    end

    patch do
      url "https://github.com/dbry/WavPack/commit/ccd367b71c51889c803bfcf4311e6b6d2b01eee3.diff"
      sha256 "04ad91aac132993fd30cc68251949af0bdc4eec4657f1d46077c26b35436bc01"
    end
  end

  bottle do
    cellar :any
    sha256 "b4638907a9b334bd9a5031afafa3f63d17d2d3e5f85eb15c615ce8aaff08b3dd" => :yosemite
    sha256 "b96271f6122b58ffbc59bd8a111afd127c33a35f94e114db9efa2a9d44ccc9a5" => :mavericks
    sha256 "1fe74ab9dbae953e2e06dd623800a8de1523d3c1651df378c339d8b6f4b3476d" => :mountain_lion
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
