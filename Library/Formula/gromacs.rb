require 'formula'

class Gromacs < Formula
  homepage 'http://www.gromacs.org/'
  url 'ftp://ftp.gromacs.org/pub/gromacs/gromacs-4.6.3.tar.gz'
  mirror 'https://fossies.org/linux/privat/gromacs-4.6.3.tar.gz'
  sha1 'bf01a19d0afdadc10b960faebbca1a68a10a4313'

  option 'enable-mpi', "Enables MPI support"
  option 'enable-double',"Enables double precision"
  option 'with-x', "Enable the X11 visualizer"

  depends_on 'cmake' => :build
  depends_on 'fftw'
  depends_on 'gsl' => :recommended
  depends_on :mpi if build.include? 'enable-mpi'
  depends_on :x11 if build.include? 'with-x'

  def install
    args = std_cmake_args
    args << "-DGMX_GSL=ON" unless build.include? 'without-gsl'
    args << "-DGMX_MPI=ON" if build.include? 'enable-mpi'
    args << "-DGMX_DOUBLE=ON" if build.include? 'enable-double'
    args << "-DGMX_X11=ON" if build.include? 'with-x'
    args << "-DGMX_CPU_ACCELERATION=None" if MacOS.version <= :snow_leopard

    inreplace 'scripts/CMakeLists.txt', 'BIN_INSTALL_DIR', 'DATA_INSTALL_DIR'

    cd "src" do
      system "cmake", "..", *args
      system "make"
      ENV.j1
      system "make install"
    end

    bash_completion.install 'scripts/completion.bash' => 'gromacs-completion.bash'
    zsh_completion.install 'scripts/completion.zsh' => '_gromacs'
  end

  def caveats;  <<-EOS.undent
    GMXRC and other scripts installed to:
      #{HOMEBREW_PREFIX}/share/gromacs
    EOS
  end
end
