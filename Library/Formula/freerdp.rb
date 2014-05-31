require "formula"

class Freerdp < Formula
  homepage "http://www.freerdp.com/"

  stable do
    url "https://github.com/FreeRDP/FreeRDP/archive/1.0.2.tar.gz"
    sha1 "aa521fc9b0610df6c03c2297c1230348805b0010"

    patch do
      url "https://github.com/FreeRDP/FreeRDP/commit/1d3289.diff"
      sha1 "294acefbfba7452baaf7af1964769f0d8ac6e46c"
    end

    patch do
      url "https://github.com/FreeRDP/FreeRDP/commit/e32f9e.diff"
      sha1 "6453e232a2f0a652d85b11b7e05ba17beefec442"
    end

    # https://github.com/FreeRDP/FreeRDP/pull/1682/files
    patch do
      url "https://gist.githubusercontent.com/bmiklautz/8832375/raw/ac77b61185d11aa69e5f6b5e88c0fa597c04d964/freerdp-1.0.2-osxversion-patch.diff"
      sha1 "2793c0251396778b763b627e68dae1e0a5d41eab"
    end
  end

  bottle do
    sha1 "361ae059c21eaccfa551b7f4924b2762a6d8d6b1" => :mavericks
    sha1 "8a82974856fa6346e7ff43b7abb6b12dc5e06634" => :mountain_lion
    sha1 "49bc6add9fec028879985d288252287ed00c8434" => :lion
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git"
    depends_on :xcode => :build # for "ibtool"
  end

  depends_on :x11
  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build

  def install
    cmake_args = std_cmake_args

    if build.head? then
      # workaround for out-of-git clone tree build
      inreplace 'cmake/GetGitRevisionDescription.cmake',
        'set(GIT_PARENT_DIR "${CMAKE_SOURCE_DIR}")',
        "set(GIT_PARENT_DIR \"#{cached_download}\")"

      inreplace 'cmake/GetGitRevisionDescription.cmake',
        'WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"',
        "WORKING_DIRECTORY \"#{cached_download}\""
      cmake_args << "-DWITH_X11=ON"
    end

    system "cmake", ".", *cmake_args
    system "make install"
  end
end
