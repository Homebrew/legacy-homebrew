class Bzip2 < Formula
  homepage "http://www.bzip.org/"
  url "http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
  sha1 "3f89f861209ce81a6bab1fd1998c0ef311712002"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/dupes"
    sha1 "5d515fa12bc177239863569721caad7987e267dc" => :yosemite
    sha1 "b250429608acd57ea5411dd6ae9b3d4675fbbffb" => :mavericks
    sha1 "07a558b9a4271377490b876c1d1cb345ee4d3f18" => :mountain_lion
  end

  keg_only :provided_by_osx

  def install
    system "make", "install", "PREFIX=#{prefix}"
    mkdir_p share
    mv prefix/"man", share

    if OS.linux?
      # Install the shared library.
      system "make", "-f", "Makefile-libbz2_so", "clean"
      system "make", "-f", "Makefile-libbz2_so"
      lib.install "libbz2.so.1.0.6", "libbz2.so.1.0"
      lib.install_symlink "libbz2.so.1.0.6" => "libbz2.so.1"
      lib.install_symlink "libbz2.so.1.0.6" => "libbz2.so"
    end
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz2"

    testfilepath.write "TEST CONTENT"

    system "#{bin}/bzip2", testfilepath
    system "#{bin}/bunzip2", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
