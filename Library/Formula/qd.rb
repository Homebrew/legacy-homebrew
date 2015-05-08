class Qd < Formula
  homepage "http://crd.lbl.gov/~dhbailey/mpdist/"
  url "http://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.15.tar.gz"
  sha256 "17d7ed554613e4c17ac18670ef49d114ba706a63d735d72032b63a8833771ff7"

  bottle do
    cellar :any
    sha1 "0b419d709130b3a5ca2e2bb6d770113c3ea16b9c" => :yosemite
    sha1 "0cedfdd4df839ff311c7cb9add9ab242fa31e66f" => :mavericks
    sha1 "a8ad0c971cf98952cf8f56c714b87ebaf4db7828" => :mountain_lion
  end

  depends_on :fortran => :recommended

  def install
    args = ["--disable-dependency-tracking", "--enable-shared", "--prefix=#{prefix}"]
    args << "--enable-fortran=no" if build.without? :fortran
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
