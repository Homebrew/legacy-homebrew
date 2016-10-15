class Odb < Formula
  homepage "http://www.codesynthesis.com/products/odb"
  url "http://www.codesynthesis.com/download/odb/2.3/odb-2.3.0.tar.gz"
  sha1 "53c851e3f3724b72d7c7a74c497c50c195729ad1"

  fails_with :clang
  fails_with :gcc_4_0
  fails_with :gcc
  fails_with :llvm
  depends_on "gcc"
  depends_on "libodb"
  
  resource "libcutl" do
    url "http://www.codesynthesis.com/download/libcutl/1.8/libcutl-1.8.1.tar.gz"
    sha1 "5411892a2959b6164321ebfb6e8e52255786b143"
  end

  patch do
    url "http://codesynthesis.com/~boris/tmp/odb/odb-2.3.0-gcc-4.9.0.patch"
    sha1 "9d0fe9db9d8667c76cd6a1bb15e911560796b656"
  end

  def install
    resource("libcutl").stage{
      system "./configure", "--prefix=#{prefix}/libcutl"
      system "make", "install"
    }
    ENV.append "CXXFLAGS", "-fno-devirtualize -I#{prefix}/libcutl/include -L#{prefix}/libcutl/lib"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", {})
    (libexec/"libexec/odb").dirname.mkpath
    (libexec/"libexec").install_symlink(libexec/"odb")
  end

  test do
    (testpath/'person.hxx').write <<-EOS.undent
      #include <odb/core.hxx>     
      #pragma db object           
      class person
      {
      private:
        friend class odb::access; 
        unsigned long id_;        
      };
    EOS
    
    system "odb", "-I#{HOMEBREW_PREFIX}/include", "-m", "dynamic", "-d", "common", "--generate-query", "person.hxx"
  end

end
