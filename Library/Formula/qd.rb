class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "http://crd.lbl.gov/~dhbailey/mpdist/"
  url "http://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.15.tar.gz"
  sha256 "17d7ed554613e4c17ac18670ef49d114ba706a63d735d72032b63a8833771ff7"

  bottle do
    cellar :any
    sha256 "b1257ee410b078479bbdcb863cd8bf8a865c67190992c19606433ff29e77852f" => :yosemite
    sha256 "2014943651c31b17c8f1463fe4f68175b2c3065a9533d7cc09c7b07a9621c51b" => :mavericks
    sha256 "380ce7cce036b99f6d203cf1f2e7d2b8ae27a78f668d933a4579ba4c887e69d8" => :mountain_lion
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
