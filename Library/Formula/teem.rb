require 'formula'

class Teem < Formula
  homepage 'http://teem.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/teem/teem/1.11.0/teem-1.11.0-src.tar.gz'
  sha1 'faafa0362abad37591bc1d01441730af462212f9'

  head 'https://teem.svn.sourceforge.net/svnroot/teem/teem/trunk'

  depends_on 'cmake' => :build

  option 'experimental-apps', "Build experimental apps"
  option 'experimental-libs', "Build experimental libs"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_SHARED_LIBS:BOOL=ON"

    if build.include? 'experimental-apps'
      cmake_args << "-DBUILD_EXPERIMENTAL_APPS:BOOL=ON"
    end
    if build.include? 'experimental-libs'
      cmake_args << "-DBUILD_EXPERIMENTAL_LIBS:BOOL=ON"
    end

    cmake_args << "."

    system "cmake", *cmake_args
    system "make install"
  end

  test do
    system "#{bin}/nrrdSanity"
  end
end
