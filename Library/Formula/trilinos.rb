require 'formula'

class Trilinos < Formula
  homepage 'http://trilinos.sandia.gov'
  url 'http://trilinos.sandia.gov/download/files/trilinos-10.12.2-Source.tar.gz'
  sha1 'bf15bbebc9bdadd43e7f58c140895078973798e1'

  option "with-scotch", "Enable Scotch partitioner"
  option "with-parmetis", "Enable ParMetis partitioner"

  depends_on MPIDependency.new(:cc, :cxx)
  depends_on 'cmake' => :build
  depends_on 'scotch'     if build.include? 'with-scotch'
  depends_on 'parmetis'   if build.include? 'with-parmetis'

  def install

    args = std_cmake_parameters.split
    args.concat [
      "-DCMAKE_BUILD_TYPE:STRING=RELEASE",
      "-DBUILD_SHARED_LIBS=ON",
      "-DTPL_ENABLE_MPI:BOOL=ON",
      "-DTPL_ENABLE_BLAS=ON",
      "-DTPL_ENABLE_LAPACK=ON",
      "-DTPL_ENABLE_Zlib:BOOL=ON",
      "-DTrilinos_ENABLE_ALL_PACKAGES=ON",
      "-DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=ON",
      "-DTrilinos_ENABLE_Fortran:BOOL=OFF",
      "-DTrilinos_ENABLE_EXAMPLES:BOOL=OFF",
      "-DTrilinos_ENABLE_TESTS=OFF",
      "-DTrilinos_ENABLE_SECONDARY_STABLE_CODE=ON",
      "-DTrilinos_VERBOSE_CONFIGURE:BOOL=OFF"
    ]

    args << "-DZoltan_ENABLE_Scotch:BOOL=ON"   if build.include? 'with-scotch'
    args << "-DZoltan_ENABLE_ParMETIS:BOOL=ON" if build.include? 'with-parmetis'

    mkdir 'build' do
      system "cmake", "..", *args
      system "make install"
    end

  end

end
