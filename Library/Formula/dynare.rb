require "formula"

class Dynare < Formula
  homepage "http://www.dynare.org"
  url "https://www.dynare.org/release/source/dynare-4.4.1.tar.xz"
  sha1 "ded88d6cacc027179e7885af78a05b2dd733ba13"

  option "with-matlab=</full/path/to/MATLAB_VER.app>", "Build mex files for Matlab"
  option "with-matlab-version=<VER>", "The version of Matlab pointed to by --with-matlab. E.g. 8.2"

  depends_on "octave"=> :recommended
  depends_on :fortran
  depends_on "fftw"
  depends_on "gsl"
  depends_on "libmatio"
  depends_on "matlab2tikz"
  depends_on "graphicsmagick" if build.with? "octave"
  depends_on "boost" => :build
  depends_on "slicot" => "with-default-integer-8" if build.with? "matlab"

  def patches
    # As installation is different between platforms, create patch to modify .m file that sets paths
    "https://gist.github.com/houtanb/9069576/raw/7e261f4f00be23b3bbcae5a7193533cb57d4983d/dynare_config.patch"
  end

  def install
    args=%W[
            --disable-debug
            --disable-dependency-tracking
            --disable-silent-rules
            --prefix=#{prefix}
    ]
    matlab_path = ARGV.value("with-matlab") || ""
    matlab_version = ARGV.value("with-matlab-version") || ""
    if matlab_path.empty? || matlab_version.empty?
      args << "--disable-matlab"
    else
      args << "--with-matlab=#{matlab_path}"
      args << "MATLAB_VERSION=#{matlab_version}"
    end
    args << "--disable-octave" if build.without? "octave"

    system "./configure", *args
    system "make"

    # make install was never set up on Dynare, hence install necessary files vio Homebrew
    # Install Preprocessor
    (lib/"dynare/matlab").install "preprocessor/dynare_m"

    # Install Octave mex/oct files
    if build.with? "octave"
      (lib/"dynare/mex/octave").install "mex/build/octave/kronecker/A_times_B_kronecker_C.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/block_kalman_filter/block_kalman_filter.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/bytecode/bytecode.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/dynare_simul_/dynare_simul_.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/gensylv/gensylv.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/k_order_perturbation/k_order_perturbation.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/kalman_steady_state/kalman_steady_state.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/local_state_space_iterations/local_state_space_iteration_2.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/mjdgges/mjdgges.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/ms_sbvar/ms_sbvar_command_line.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/ms_sbvar/ms_sbvar_create_init_file.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/ordschur/ordschur.oct"
      (lib/"dynare/mex/octave").install "mex/build/octave/sobol/qmc_sequence.mex"
      (lib/"dynare/mex/octave").install "mex/build/octave/qzcomplex/qzcomplex.oct"
      (lib/"dynare/mex/octave").install "mex/build/octave/kronecker/sparse_hessian_times_B_kronecker_C.mex"
    end

    # Install Matlab mex files
    if !matlab_version.empty? && !matlab_version.empty?
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/kronecker/A_times_B_kronecker_C.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/block_kalman_filter/block_kalman_filter.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/bytecode/bytecode.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/dynare_simul_/dynare_simul_.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/gensylv/gensylv.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/k_order_perturbation/k_order_perturbation.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/kalman_steady_state/kalman_steady_state.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/local_state_space_iterations/local_state_space_iteration_2.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/mjdgges/mjdgges.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/ms_sbvar/ms_sbvar_command_line.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/ms_sbvar/ms_sbvar_create_init_file.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/sobol/qmc_sequence.mex*")
      (lib/"dynare/mex/matlab").install Dir.glob("mex/build/matlab/kronecker/sparse_hessian_times_B_kronecker_C.mex*")
    end

    # Install Matlab/Octave m files
    (share/"dynare/").install Dir["matlab"]
    (share/"dynare/contrib/ms-sbvar/").install Dir["contrib/ms-sbvar/TZcode"]

    # Install dynare++ executable
    bin.install("dynare++/src/dynare++")
  end

  def caveats
    s = <<-EOS.undent
    To get started with dynare, open Matlab or Octave and type:

            addpath #{HOMEBREW_PREFIX}/share/dynare/matlab
    EOS
  end
end
