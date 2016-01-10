class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.6.0.tar.bz2"
  sha256 "0ece824e0da27b384d11d1de371f20cafac465e038041adab57fcf4b5036ef8d"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "630d2923a804c7a442f6466adf5d6aa21f5f1602f6b005760199a85c14758adc" => :el_capitan
    sha256 "82d8e9279d977a9591450142bf90015df62f800df026038a170d7db6d20a198a" => :yosemite
    sha256 "48c70bdab7cffbc780d15c1d903ae1b7dd80552ed7762e8168629dc1df920fce" => :mavericks
    sha256 "1b48570302d9357be80e10a3dfd0362863ced93c111cc827c7fab7b2e79dae9e" => :mountain_lion
  end

  option "with-gettext", "Build with Native Language Support"

  depends_on "gettext" => :optional

  fails_with :llvm do
    build 2334
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--disable-nls" if build.without? "gettext"

    system "./configure", *args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip
  end
end
