class SoundTouch < Formula
  desc "Audio processing library"
  homepage "http://www.surina.net/soundtouch/"
  url "http://www.surina.net/soundtouch/soundtouch-1.8.0.tar.gz"
  sha256 "3d4161d74ca25c5a98c69dbb8ea10fd2be409ba1a3a0bf81db407c4c261f166b"

  bottle do
    cellar :any
    sha1 "ba626eb84b2e8e82b4e2b608534f13800da00994" => :mavericks
    sha1 "9dbb7296e5b8ea20790d97ee43967614dba9b584" => :mountain_lion
    sha1 "728d89303b4cd85cd95f1ad625007d164c1f64bb" => :lion
  end

  option "with-integer-samples", "Build using integer samples? (default is float)"
  option :universal

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh", "bootstrap"
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    args << "--enable-integer-samples" if build.with? "integer-samples"

    ENV.universal_binary if build.universal?

    system "./configure", *args
    system "make", "install"
  end
end
