class Capnp < Formula
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.5.1.tar.gz"
  sha1 "98565b2a79f4748f0f9e02fbff80fbb8803ac9fc"

  bottle do
    sha1 "c73a3d2118d22e1741cea71b5557a98f1f9123d3" => :yosemite
    sha1 "25029d69b65d8cb98dc5015a9c215e5109e889ba" => :mavericks
    sha1 "06576d9fbc1ee122828bf7f41ceb5cb12bc41a32" => :mountain_lion
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
