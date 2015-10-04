class Normalize < Formula
  desc "Adjust volume of audio files to a standard level"
  homepage "http://normalize.nongnu.org/"
  url "http://savannah.nongnu.org/download/normalize/normalize-0.7.7.tar.gz"
  sha256 "6055a2abccc64296e1c38f9652f2056d3a3c096538e164b8b9526e10b486b3d8"

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
    system "#{bin}/normalize"
  end
end
