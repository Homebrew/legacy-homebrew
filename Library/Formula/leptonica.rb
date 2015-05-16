require 'formula'

class Leptonica < Formula
  homepage 'http://www.leptonica.org/'
  url 'http://www.leptonica.org/source/leptonica-1.71.tar.gz'
  sha1 '1ee59b06fd6c6402876f46c26c21b17ffd3c9b6b'
  revision 1

  bottle do
    cellar :any
    sha1 "f492ae6f99b341c2fb1f32cadb44402963e3c8ae" => :yosemite
    sha1 "793835a4e3b6bb19601f842c7a5de5873e340451" => :mavericks
    sha1 "cba822e6f2e5d1c87789fbcd6c0e78cef487b134" => :mountain_lion
  end

  depends_on 'libpng' => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :recommended
  depends_on 'giflib' => :optional
  depends_on 'openjpeg' => :optional
  depends_on 'webp' => :optional
  depends_on 'pkg-config' => :build

  conflicts_with 'osxutils',
    :because => "both leptonica and osxutils ship a `fileinfo` executable."

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    %w[libpng jpeg libtiff giflib].each do |dep|
      args << "--without-#{dep}" if build.without?(dep)
    end
    %w[openjpeg webp].each do |dep|
      args << "--with-lib#{dep}" if build.with?(dep)
      args << "--without-lib#{dep}" if build.without?(dep)
    end

    system "./configure", *args
    system "make install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
    #include <iostream>
    #include <leptonica/allheaders.h>

    int main(int argc, char **argv) {
        std::fprintf(stdout, "%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION);
        return 0;
    }
    EOS

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, `./a.out`
  end
end
