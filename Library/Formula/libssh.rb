class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/154/libssh-0.7.1.tar.xz"
  sha256 "2fc7ccf96d3263cbd8ab520118cb94d9a2e11714c61e22b3f761fc5352fd046d"

  head "git://git.libssh.org/projects/libssh.git"

  bottle do
    sha256 "d4c38799d5f43f7f19d69f5733f884604944cde5458383cf5133ce449524fada" => :yosemite
    sha256 "f316f85527d2ff721eb897fff84329610241224462d396ff6afdbd0f41b7c73c" => :mavericks
    sha256 "a090f18299ad75737715fb0b1dd37fff809dc10383232a65c4849f61a7197bf7" => :mountain_lion
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
