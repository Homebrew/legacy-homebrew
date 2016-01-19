class SoundTouch < Formula
  desc "Audio processing library"
  homepage "http://www.surina.net/soundtouch/"
  url "http://www.surina.net/soundtouch/soundtouch-1.9.2.tar.gz"
  sha256 "caeb86511e81420eeb454cb5db53f56d96b8451d37d89af6e55b12eb4da1c513"

  bottle do
    cellar :any
    sha256 "71d50484d79decdb52b05893e28d86a5996b73c9174cc9e266647f04d1afccca" => :el_capitan
    sha256 "fdd99f6a7879b3b65ad8283f3072afccedf7cb9c82b126a1a96a242a6b20cc07" => :yosemite
    sha256 "c2a721df1155a2a87de6c3e3f756b812ed37e69c98dfad170e5a1e327018578a" => :mavericks
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
