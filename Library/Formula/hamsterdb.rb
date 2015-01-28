class JavaRequirement < Requirement
  fatal true

  def self.jdk_home
    [
      `/usr/libexec/java_home`.chomp,
      ENV['JAVA_HOME']
    ].find { |dir| dir && File.exist?("#{dir}/bin/javac") && File.exist?("#{dir}/include") }
  end

  satisfy :build_env => false do
    self.class.jdk_home
  end

  def message; <<-EOS.undent
    Could not find a JDK (i.e. not a JRE)

    Do one of the following:
    - install a JDK that is detected with /usr/libexec/java_home
    - set the JAVA_HOME environment variable
    - specify --without-java
    EOS
  end
end

class Hamsterdb < Formula
  homepage "http://hamsterdb.com"
  url "http://files.hamsterdb.com/dl/hamsterdb-2.1.9.tar.gz"
  sha1 "036817e4ccc9c4b23affb987c149ebd04696f1d0"

  bottle do
    cellar :any
    sha1 "b4b9b5642f17f3fd22f435309c6bfdb3eb4be13a" => :yosemite
    sha1 "d8766c2c04563e2e471bed85e43945bcd402c4dc" => :mavericks
    sha1 "f08ff2613c4caaba89d21d8bb3ddc5be332847c1" => :mountain_lion
  end

  option "without-java", "Do not build the Java wrapper"
  option "without-remote", "Disable access to remote databases"

  head do
    url "https://github.com/cruppstahl/hamsterdb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"
  depends_on "gnutls"
  depends_on JavaRequirement if build.with? "java"
  depends_on "protobuf" if build.with? "remote"

  resource "libuv" do
    url "https://github.com/libuv/libuv/archive/v0.10.31.tar.gz"
    sha1 "9ab8ecb10f90ce13404ff58ff85cb774472e2cb9"
  end

  stable do
    # patch upstream commits:
    # https://github.com/cruppstahl/hamsterdb/commit/6a8dd20ec9bd2ec718d1136db7667e0e58911003
    # https://github.com/cruppstahl/hamsterdb/commit/1447ba4eb217532e8fb49c4a84a0dc3b982a3ffe
    patch do
      url "https://gist.githubusercontent.com/xu-cheng/0d5fa0b6b81426f68271/raw/47ff326c43a1865cda8e9fa9d00434c68efa7e13/hamsterdb.diff"
      sha1 "e83346c3afc92d6450ceef1c34adce1a515b245e"
    end
  end

  fails_with :clang do
    build 503
    cause "error: member access into incomplete type 'const std::type_info'"
  end

  def install
    system "/bin/sh", "bootstrap.sh" if build.head?

    features = []

    if build.with? "java"
      features << "JDK=#{JavaRequirement.jdk_home}"
    else
      features << "--disable-java"
    end

    if build.with? "remote"
      resource("libuv").stage do
        system "make", "libuv.dylib"
        (libexec/"libuv/lib").install "libuv.dylib"
        (libexec/"libuv").install "include"
      end

      ENV.prepend "LDFLAGS", "-L#{libexec}/libuv/lib"
      ENV.prepend "CFLAGS", "-I#{libexec}/libuv/include"
      ENV.prepend "CPPFLAGS", "-I#{libexec}/libuv/include"
    else
      features << "--disable-remote"
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *features
    system "make", "install"
  end

  test do
    system "#{bin}/ham_info -h"
  end
end
