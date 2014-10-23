require 'formula'

class Leptonica < Formula
  homepage 'http://www.leptonica.org/'
  url 'http://www.leptonica.org/source/leptonica-1.71.tar.gz'
  sha1 '1ee59b06fd6c6402876f46c26c21b17ffd3c9b6b'

  bottle do
    cellar :any
    revision 2
    sha1 "6d6139b159eb9cc8827932362b015530d867303a" => :yosemite
    sha1 "4f6aef3ad34456c8d683ed316d9b5768862aeb87" => :mavericks
    sha1 "b32efefe40bba7e3d96ccde1271c5856110611ce" => :mountain_lion
  end

  depends_on 'libpng' => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :optional
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
