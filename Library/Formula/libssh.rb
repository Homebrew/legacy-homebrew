class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/195/libssh-0.7.3.tar.xz"
  sha256 "26ef46be555da21112c01e4b9f5e3abba9194485c8822ab55ba3d6496222af98"
  head "git://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "d631ef47a2de9b3947f24ad4b9704761c1fcd6caaca0dcda62566c2e9fee14f3" => :el_capitan
    sha256 "dbb548a37ef0b7923c24fb138a0cf227b47d0be577a56adc5d8b4a63c2ac0564" => :yosemite
    sha256 "c173a69c283ab16bdbd1478f87505548fb7cff83e04752d6f776721b85764b2e" => :mavericks
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
