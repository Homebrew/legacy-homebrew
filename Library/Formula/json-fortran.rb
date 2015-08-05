class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/4.2.0.tar.gz"
  sha256 "5cf12ce527809b644ae35a0a34ce330804285d3b7987b17488d1752330dd7a81"

  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    sha256 "bb9cbce17fa229548bb63d71c4905a669ddeca4c4d18553e5a2d9fb5da6a29a5" => :yosemite
    sha256 "2bedbab56f3f1e042423732ae20e69318e26a42143f66461148794f1913db03c" => :mavericks
    sha256 "0c2ec996d2fe95095a66cfe2aa6f4de7b995edf729494b02b3bc251b9007d8f4" => :mountain_lion
  end

  option "with-unicode-support", "Build json-fortran to support unicode text in json objects and files"
  option "without-test", "Skip running build-time tests (not recommended)"
  option "without-docs", "Do not build and install FORD generated documentation for json-fortran"

  deprecated_option "without-robodoc" => "without-docs"

  depends_on "ford" => :build if build.with? "docs"
  depends_on "cmake" => :build
  depends_on :fortran

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE" # Use more GNU/Homebrew-like install layout
      args << "-DENABLE_UNICODE:BOOL=TRUE" if build.with? "unicode-support"
      args << "-DSKIP_DOC_GEN:BOOL=TRUE" if build.without? "docs"
      system "cmake", "..", *args
      system "make", "check" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    ENV.fortran
    (testpath/"json_test.f90").write <<-EOS.undent
      program json_test
        use json_module
        use ,intrinsic :: iso_fortran_env ,only: error_unit
        implicit none
        call json_initialize()
        if ( json_failed() ) then
          call json_print_error_message(error_unit)
          stop 2
        endif
      end program
    EOS
    system ENV.fc, "-ojson_test", "-ljsonfortran", "-I#{HOMEBREW_PREFIX}/include", testpath/"json_test.f90"
    system "./json_test"
  end
end
