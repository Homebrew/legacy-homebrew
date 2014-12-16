require 'formula'

class GooglePerftools < Formula
  homepage 'http://code.google.com/p/gperftools/'
  url "https://googledrive.com/host/0B6NtGsLhIcf7MWxMMF9JdTN3UVk/gperftools-2.3.tar.gz"
  sha1 "3f7d48a8dfd519f744d94cd2dc6a7875e456e632"

  bottle do
    cellar :any
    sha1 "c5f3fcc3e72965cdf5a60b3ff26e5b8fcc1f6bd2" => :yosemite
    sha1 "c930c122d93509860ed775647b6087ff47209646" => :mavericks
    sha1 "012d32851ca538fd32cd85db4fe8b033cfe38755" => :mountain_lion
  end

  fails_with :llvm do
    build 2326
    cause "Segfault during linking"
  end

  def install
    ENV.append_to_cflags '-D_XOPEN_SOURCE'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
