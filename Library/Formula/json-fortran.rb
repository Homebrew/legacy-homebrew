class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/4.2.0.tar.gz"
  sha256 "5cf12ce527809b644ae35a0a34ce330804285d3b7987b17488d1752330dd7a81"

  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    sha256 "3b6410ef26c24d63f90e420aae0157f7d97b4d154b398305863e2be6c24eed8d" => :yosemite
    sha256 "5608f04857515ce6b38d6a7ade2cf50a15541cb307ff97cbde1d367af3b19801" => :mavericks
    sha256 "443ce5965a801c7e3dda0dfc5762b9f84ec97bf450d98eedfe0385d3681a725e" => :mountain_lion
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
