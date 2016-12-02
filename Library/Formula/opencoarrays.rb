class Opencoarrays < Formula
  desc "open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/opencoarrays/releases/download/1.3.2/OpenCoarrays-1.3.2.tar.gz"
  sha256 "391937a5d24962bd93ecec2402545a3e9d6c7a43987082c7de7dee3b74151ec3"

  head "https://github.com/sourceryinstitute/opencoarrays.git"

  option "without-test", "Skip build time tests (requires properly configured MPICH and firewall settings)"

  depends_on :fortran
  depends_on :mpi => [:cc, :f90]
  depends_on "cmake" => :build

  # GCC >= 5.2 required; no other Homebrew supported compilers are compatible
  # but the mpicc compiler may be clang (which is ABI compatible with GCC)
  fails_with :llvm
  fails_with :gcc
  fails_with :gcc_4_0
  ("4.3".."4.9").each do |series|
    fails_with :gcc => series
  end
  fails_with :gcc => "5.1"

  def install
    mkdir "build" do
      ENV["FC"] = ENV["MPIFC"]
      ENV["CC"] = ENV["MPICC"]
      cmake_args = std_cmake_args
      system "cmake", "..", *cmake_args
      system "make"
      # A bug in GFortran <= 5.2 causes the "co_reduce" test to fail; find
      # which version of gfortran is being used, and skip the test if needed.
      gfortran_version = /\d\.\d+/.match(`mpif90 --version`)
      test_excludes = []
      test_excludes = ["-E", "co_reduce"] if gfortran_version.to_s < "5.3"
      system "ctest", *test_excludes if build.with? "test"
      system "make", "install"
    end
  end

  test do
    ENV.fortran
    (testpath/"tally.f90").write <<-EOS.undent
      program main
        use iso_c_binding, only : c_int
        use iso_fortran_env, only : error_unit
        implicit none
        integer(c_int) :: tally
        tally = this_image() ! this image's contribution
        call co_sum(tally)
        verify: block
          integer(c_int) :: image
          if (tally/=sum([(image,image=1,num_images())])) then
             write(error_unit,'(a,i5)') "Incorrect tally on image ",this_image()
             error stop 2
          end if
        end block verify
        ! Wait for all images to pass the test
        sync all
        if (this_image()==1) write(*,*) "Test passed"
      end program
    EOS
    system "#{bin}/caf", "tally.f90", "-o", "tally"
    system "#{bin}/cafrun", "-np", "3", "./tally"
  end
end
