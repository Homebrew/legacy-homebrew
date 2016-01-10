class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/4.3.0.tar.gz"
  sha256 "c97f8de53e2ca9ee91fb3148bfa971b00eaea6e757b5e3d67cc4b4ff197e392e"

  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    sha256 "a80853e1da087f33cccfc10f1ebce1f77339a211d3223347d8659d977965ea50" => :el_capitan
    sha256 "f790c4a3c3ff3a720fd69ee70b6bec42f13c5d0c0f4dee433e1b40ce73630f23" => :yosemite
    sha256 "f908838becce85cf6cba0f355b66f677695d9e718b6a1e4d3f46db327f884058" => :mavericks
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
