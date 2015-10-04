class UnittestCpp < Formula
  desc "Unit testing framework for C++"
  homepage "https://github.com/unittest-cpp/unittest-cpp"

  stable do
    url "https://github.com/unittest-cpp/unittest-cpp/archive/v1.4.tar.gz"
    sha256 "e075760b7082380058e7bbe3a69f8739524c73dc82d8362b418aaa0f873c6c20"

    # Clang failure fixed in the HEAD already
    fails_with :clang do
      build 600
      cause "Failure in test: Expected 2 but was 0"
    end
  end

  bottle do
    cellar :any
    sha1 "6d9dbaebbfce4e6da037f55d70766b305ae361de" => :yosemite
    sha1 "6042952c71d97f611f7dc6662125e02fb1a3f56a" => :mavericks
    sha1 "e0289f35b526795fad1d204374928996f7f208a2" => :mountain_lion
  end

  head do
    url "https://github.com/unittest-cpp/unittest-cpp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{prefix}", "--disable-silent-rules"
      system "make", "install"
    end

    if build.stable?
      system "make"

      # Install the headers
      include.install Dir["src/*.h"]
      include.install "src/Posix"

      # Install the compiled library
      lib.install "libUnitTest++.a"

      # Install the documentation
      doc.install "docs/UnitTest++.html"
    end
  end
end
