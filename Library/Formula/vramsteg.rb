require 'formula'

class Vramsteg < Formula
  homepage 'http://tasktools.org/projects/vramsteg.html'
  url 'http://taskwarrior.org/download/vramsteg-1.0.1.tar.gz'
  sha1 'bbc9f54e6e10b3e82dbbac6275e2e611d752e85d'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test vramsteg`.
    system "false"
  end
end
