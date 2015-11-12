class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/154/libssh-0.7.1.tar.xz"
  mirror "http://sources.buildroot.net/libssh-0.7.1.tar.xz"
  sha256 "2fc7ccf96d3263cbd8ab520118cb94d9a2e11714c61e22b3f761fc5352fd046d"

  head "git://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    revision 1
    sha256 "09f1395ab2b200acc9ef148ce34ffd06e793c5d01e81b38e514fc04178de8446" => :el_capitan
    sha256 "99d3af0dd4b187716008cda69583b5a2bbae9e2df86404eda2b8938b60f71bd5" => :yosemite
    sha256 "59db885db693b5064a45bd89cbe603bfb4261908e8bac03eafd6d8180d400a7a" => :mavericks
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
