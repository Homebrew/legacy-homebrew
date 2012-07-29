require 'formula'

class Parmetis < Formula
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.2.tar.gz'
  homepage 'http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview'
  md5 '0912a953da5bb9b5e5e10542298ffdce'

  depends_on 'cmake' => :build
  depends_on MPIDependency.new(:cc,:cxx)

  def install
    # Install Metis
    Dir.chdir 'metis' do
      # Wrapper around a CMake configuration
      system "make" , "config" , "shared=1" , "prefix=#{prefix}"
      system 'make install'
    end    

    # Install ParMETIS
    # This flag is set when using clang. But as the mpi wrappers might be wrapping llvm,
    # and CMake says it can't compile with this, remove it.
    ENV.remove_from_cflags /-march=native/

    # Wrapper around a CMake configuration
    system "make" , "config" , "shared=1" , "cc=#{ENV['MPICC']}" , "cxx=#{ENV['MPICXX']}" , "prefix=#{prefix}"
    system 'make install'    
  end
end
