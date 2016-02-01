class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/milancurcic/datetime-fortran"
  url "https://github.com/milancurcic/datetime-fortran/releases/download/v1.4.2/datetime-fortran-1.4.2.tar.gz"
  sha256 "5b70c6e5d38032951e879b437e9ac7c5d483860ce8a9f6bbe6f1d6cd777e737f"

  bottle do
    cellar :any_skip_relocation
    sha256 "38dc388b455327e84f09132794a4a116bd15d5da943bc8beb9a54d86f24e6f8d" => :el_capitan
    sha256 "7946958a4af7b3ceab82df7f5daddae1fcc659a01368e3e96e30b2961eb822cf" => :yosemite
    sha256 "c79a7073c0868cce8aba565992fcc30cba5920deb873c8ba480e23a656bf7457" => :mavericks
  end

  head do
    url "https://github.com/milancurcic/datetime-fortran.git"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "pkg-config" => :build
  end

  option "without-test", "Skip build time tests (Not recommended)"
  depends_on :fortran

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "check" if build.with? "test"
    system "make", "install"
    (pkgshare/"test").install "src/tests/datetime_tests.f90"
  end

  test do
    ENV.fortran
    system ENV.fc, "-odatetime_test", "-ldatetime", "-I#{HOMEBREW_PREFIX}/include", pkgshare/"test/datetime_tests.f90"
    system testpath/"datetime_test"
  end
end
