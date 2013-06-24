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
    [
      'https://github.com/FreeRDP/FreeRDP/commit/1d3289.patch',
      'https://github.com/FreeRDP/FreeRDP/commit/e32f9e.patch'
    ]
  end unless build.head?

  def install
    if build.head? then
      # workaround for out-of-git clone tree build
      inreplace 'cmake/GetGitRevisionDescription.cmake',
        'set(GIT_PARENT_DIR "${CMAKE_SOURCE_DIR}")',
        "set(GIT_PARENT_DIR \"#{cached_download}\")"

      inreplace 'cmake/GetGitRevisionDescription.cmake',
        'WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"',
        "WORKING_DIRECTORY \"#{cached_download}\""
    end

    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
