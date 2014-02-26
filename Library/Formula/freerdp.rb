require 'formula'

class Freerdp < Formula
  homepage 'http://www.freerdp.com/'
  url 'https://github.com/FreeRDP/FreeRDP/archive/1.0.2.tar.gz'
  sha1 'aa521fc9b0610df6c03c2297c1230348805b0010'

  head 'https://github.com/FreeRDP/FreeRDP.git'

  depends_on :x11
  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build

  # Upstream; check for removal on 1.1 release.
  def patches
    unless build.head?
      [
        'https://github.com/FreeRDP/FreeRDP/commit/1d3289.patch',
        'https://github.com/FreeRDP/FreeRDP/commit/e32f9e.patch',
        # https://github.com/FreeRDP/FreeRDP/pull/1682/files
        'https://gist.github.com/bmiklautz/8832375/raw/ac77b61185d11aa69e5f6b5e88c0fa597c04d964/freerdp-1.0.2-osxversion-patch.diff'
      ]
    end
  end

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
