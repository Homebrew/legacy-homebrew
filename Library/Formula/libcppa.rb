require 'formula'

class Libcppa < Formula
  homepage 'http://libcppa.blogspot.it'
  url 'https://github.com/Neverlord/libcppa/archive/V0.7.1.tar.gz'
  sha1 '0f1f685e94bfa16625370b978ff26deaf799b94e'

  depends_on 'cmake' => :build

  option 'with-opencl', 'Build with OpenCL actors'
  option 'disable-context-switching', 'Compile libcppa without context-switching actors even if Boost.Context is available'

  def install
    args = %W[
      --prefix=#{prefix}
      --build-static
    ]

    if build.with? 'opencl'
      args << "--with-opencl"
    end

    if build.include? 'disable-context-switching'
      args << "--disable-context-switching"
    end

    system "./configure", *args
    system "make"
    system "make", "test"
    system "make", "install"
  end
end
