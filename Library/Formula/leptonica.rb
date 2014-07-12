require 'formula'

class Leptonica < Formula
  homepage 'http://www.leptonica.org/'
  url 'http://www.leptonica.org/source/leptonica-1.71.tar.gz'
  sha1 '1ee59b06fd6c6402876f46c26c21b17ffd3c9b6b'

  bottle do
    cellar :any
    revision 1
    sha1 "ad82e1ecacdee2428e2c7426198969db363a09c5" => :mavericks
    sha1 "971d13992a410a6d4907cb4c964151ae5cd5ffe2" => :mountain_lion
    sha1 "9e58252edeb5ef713a24fe89a154cd25ec98b0a9" => :lion
  end

  depends_on 'libpng' => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :optional
  depends_on 'pkg-config' => :build

  conflicts_with 'osxutils',
    :because => "both leptonica and osxutils ship a `fileinfo` executable."

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    %w[libpng jpeg libtiff].each do |dep|
      args << "--without-#{dep}" if build.without?(dep)
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
