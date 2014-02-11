require 'formula'

class Libcppa < Formula
    homepage 'http://libcppa.blogspot.it'
    url 'http://github.com/Neverlord/libcppa/archive/V0.8.1.tar.gz'
    sha1 '3f7812826195ed5d75c4fca8b8d85d61d714f066'
    
    depends_on :macos => :lion
    depends_on 'cmake' => :build
    
    option 'with-opencl', 'Build with OpenCL actors'
    
    fails_with :gcc do
    cause 'libcppa requires a C++11 compliant compiler.'
end

fails_with :llvm do
    cause 'libcppa requires a C++11 compliant compiler.'
end

def install
    args = %W[
    --prefix=#{prefix}
    --build-static
    --disable-context-switching
    ]
    
    args << "--with-opencl" if build.with? 'opencl'
    
    system "./configure", *args
    system "make"
    system "make", "test"
    system "make", "install"
end
end
