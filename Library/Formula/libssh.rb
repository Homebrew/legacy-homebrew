class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/154/libssh-0.7.1.tar.xz"
  sha256 "2fc7ccf96d3263cbd8ab520118cb94d9a2e11714c61e22b3f761fc5352fd046d"

  head "git://git.libssh.org/projects/libssh.git"

  bottle do
    sha1 "de5ef207ed3ae4d79f180a5835fe491409a0804d" => :yosemite
    sha1 "3de5d0a02be7bda59dabe91cd7db4ece978d25bb" => :mavericks
    sha1 "983355b795316434c54dd61e85495a808a147845" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libssh/libssh.h>
      #include <stdlib.h>
      int main()
      {
        ssh_session my_ssh_session = ssh_new();
        if (my_ssh_session == NULL)
          exit(-1);
        ssh_free(my_ssh_session);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lssh",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
