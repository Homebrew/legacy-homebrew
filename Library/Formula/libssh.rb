class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/195/libssh-0.7.3.tar.xz"
  sha256 "26ef46be555da21112c01e4b9f5e3abba9194485c8822ab55ba3d6496222af98"
  head "git://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "962514e8ac6b60a0d12e1c9e7330d844404c84a5ccf6f5663f191dc086c3bd8f" => :el_capitan
    sha256 "15a9b8adb6eef8802e3a7eb3bbcbe336b9876fae4a0c3f69d7af63bc9da84926" => :yosemite
    sha256 "0827ae77b0c7633f25e13eca2fd8c82905de15252f602ddcc55f121cdfef9b52" => :mavericks
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
