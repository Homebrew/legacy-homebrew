require 'formula'

class Libcppa < Formula
  homepage 'http://libcppa.blogspot.it'
  url 'https://github.com/Neverlord/libcppa/archive/V0.8.1.tar.gz'
  sha1 'd4f096aae2bb72e254ad6df45edf3fb62370acaa'

  depends_on 'cmake' => :build

  needs :cxx11

  option 'with-opencl', 'Build with OpenCL actors'
  option 'with-examples', 'Build examples'

  def install
    args = %W[
      --prefix=#{prefix}
      --build-static
      --disable-context-switching
    ]

    args << '--with-opencl' if build.with? 'opencl'
    args << '--no-examples' if build.without? 'examples'

    system "./configure", *args
    system "make"
    system "make", "test"
    system "make", "install"
  end
end
