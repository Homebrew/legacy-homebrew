class Capnp < Formula
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.5.1.2.tar.gz"
  sha256 "a23f462bb863ee867783ff33e4c2c9e3ece684c6b33410e34ed2eb17b5d90929"

  bottle do
    sha1 "8efac5284bcf2f16378c93d5384c5459cc0aa684" => :yosemite
    sha1 "c469a616d9d94e0cfcce9e93f8a0623511055fd1" => :mavericks
    sha1 "23ed9c4e64f5b3b08774731d23a0c2cd041bb647" => :mountain_lion
  end

  needs :cxx11
  option "without-shared", "Disable building shared library variant"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--disable-shared" if build.without? "shared"

    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/capnp", "--version"
  end
end
