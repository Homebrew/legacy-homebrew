class Opencoarrays < Formula
  desc "open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/opencoarrays/releases/download/1.2.1/opencoarrays-1.2.1.tar.gz"
  sha256 "2771a8f6d44f6492d0b30731ab7b7803bfea1a14aab4f6936ddd2a400956e2bb"

  head "https://github.com/sourceryinstitute/opencoarrays.git"

  option "without-test", "Skip build time tests (requires properly configured MPICH and firewall settings)"

  depends_on :fortran
  depends_on :mpi => [:cc, :f90, "with-fortran"]
  depends_on "cmake" => :build

  # GCC >= 5.2 required; no other Homebrew supported compilers are compatible
  # but the mpicc compiler may be clang (which is ABI compatible with GCC)
  fails_with :llvm
  fails_with :clang
  fails_with :gcc
  fails_with :gcc_4_0
  ("4.3".."4.9").each do |series|
    fails_with :gcc => series
  end
  fails_with :gcc => "5.1"

  def install
    mkdir "build" do
      ENV["FC"] = "mpif90"
      ENV["CC"] = "mpicc"
      # Release build type in std_cmake_args can break the build due to GCC bugs
      # at certain optimization levels. See sourceryinstitute/opencoarrays#28
      # for further details
      cmake_args = std_cmake_args
      cmake_args.delete("-DCMAKE_BUILD_TYPE=Release")
      system "cmake", "..", *cmake_args
      system "make"
      # see sourceryinstitute/opencoarrays/blob/master/STATUS.md#compiler-issues-gnu
      gfortran_version = /\d\.\d+/.match(`mpif90 --version`)
      test_excludes = ["-E", "co_reduce"] if gfortran_version.to_s < "5.3"
      system "ctest", *test_excludes if build.with? "test"
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    If the firewall is enabled, it is normal to receive pop-up messages asking
    permission to accept incomming connections due to MPI during the build, unless
    `--without-test` is specified. Additionally `brew test opencoarrays` will also
    cause these firewall notifications. They may be safely ignored, or they may be
    prevented by momentarily disabling the Mac OS X firewall under security
    settings.

    GCC >= 5.2 is required to build and use OpenCoarrays. Additionally MPICH is
    prefered to OpenMPI.

    For a list of known issues please see:
    https://github.com/sourceryinstitute/opencoarrays/blob/master/STATUS.md#known-issues
    EOS
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
    system "#{bin}/cafrun", "-np", "3", "./tally" # non-zero exit indicates failure
  end
end
