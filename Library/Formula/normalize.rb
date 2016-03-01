class Normalize < Formula
  desc "Adjust volume of audio files to a standard level"
  homepage "http://normalize.nongnu.org/"
  url "https://savannah.nongnu.org/download/normalize/normalize-0.7.7.tar.gz"
  sha256 "6055a2abccc64296e1c38f9652f2056d3a3c096538e164b8b9526e10b486b3d8"

  bottle do
    cellar :any
    revision 1
    sha256 "052ab2e8b1f6a2aa1e634a30749612d927b5cee5cc9302e057bd02c599a1c256" => :el_capitan
    sha256 "dcb42f107b9674e50d8994215f6d125e0fb9523b1d99b393fd00ee2b827be5e0" => :yosemite
    sha256 "9c12615d384a706feb8ddb693dadacfc5bfc48827e5722dd6476325bbe5e90b9" => :mavericks
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
