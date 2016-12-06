require 'formula'

class ParallelNetcdf < Formula
  homepage 'http://trac.mcs.anl.gov/projects/parallel-netcdf'
  url 'http://ftp.mcs.anl.gov/pub/parallel-netcdf/parallel-netcdf-1.3.1.tar.gz'
  sha1 'f9860d174a4741e7f80a71e29fabbe170402f535'

  depends_on MPIDependency.new(:cc, :cxx, :f77, :f90)

  # This formula depends on MPI, i.e. if it does not work
  # as is, try with --env=std

  def install
    ENV.j1
    ENV['MPICC'] = "#{HOMEBREW_PREFIX}/bin/mpicc"
    ENV['MPICXX'] = "#{HOMEBREW_PREFIX}/bin/mpicxx"
    ENV['MPIF90'] = "#{HOMEBREW_PREFIX}/bin/mpif77"
    ENV['MPIF77'] = "#{HOMEBREW_PREFIX}/bin/mpif90"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
