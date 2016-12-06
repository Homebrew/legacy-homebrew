require 'formula'

class Zoltan < Formula
  url 'http://trilinos.sandia.gov/download/files/trilinos-10.6.4-Source.tar.gz'
  homepage 'http://www.cs.sandia.gov/Zoltan'
  md5 '75b393e633bde4d9565df304f84b52e4'
  version '3.3'

  def options
    [
      ["--with-scotch", "Enable PT-Scotch support"],
    ]
  end

  depends_on 'cmake' => :build
  depends_on 'scotch'   if ARGV.include? '--with-scotch'

  def install

    mkdir 'zoltan-build'

    args = std_cmake_parameters.split
    args.concat [
      "-DTPL_ENABLE_MPI:BOOL=ON",   
      "-DTrilinos_ENABLE_Fortran:BOOL=OFF", 
      "-DTrilinos_ENABLE_EXAMPLES:BOOL=OFF",
      "-DTrilinos_VERBOSE_CONFIGURE:BOOL=OFF",  
      "-DTrilinos_ENABLE_ALL_PACKAGES:BOOL=OFF",
      "-DTrilinos_ENABLE_Zoltan:BOOL=ON",   
      "-DZoltan_ENABLE_EXAMPLES:BOOL=OFF",
      "-DZoltan_ENABLE_TESTS:BOOL=OFF"
    ]
    args << "-DZoltan_ENABLE_Scotch:BOOL=ON"   if ARGV.include? '--with-scotch'

    Dir.chdir 'zoltan-build' do
      system "cmake", "..", *args
      system "make install"
    end
  end
end
