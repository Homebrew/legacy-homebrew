class SoundTouch < Formula
  desc "Audio processing library"
  homepage "http://www.surina.net/soundtouch/"
  url "http://www.surina.net/soundtouch/soundtouch-1.9.1.tar.gz"
  sha256 "7d22e09e5e0a5bb8669da4f97ec1d6ee324aa3e7515db7fa2554d08f5259aecd"

  bottle do
    cellar :any
    sha256 "ec3cebf59b93b32cfce7e257e4dbf29f69902e968c357e42c5af6bac7c501ca9" => :el_capitan
    sha256 "f0825880145526db97129bb02690a5823e69f008bb83713fed7b79a9fabc1636" => :yosemite
    sha256 "75ae537da4d561053c0b974dfe77da16fafc72bafbc47b84e393d142afd5be73" => :mavericks
  end

  option "with-integer-samples", "Build using integer samples? (default is float)"
  option :universal

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh", "bootstrap"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--enable-integer-samples" if build.with? "integer-samples"

    ENV.universal_binary if build.universal?

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match /SoundStretch v#{version} -/, shell_output("#{bin}/soundstretch 2>&1", 255)
  end
end
