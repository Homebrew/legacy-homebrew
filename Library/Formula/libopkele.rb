class Libopkele < Formula
  desc "C++ implementation of OpenID decentralized identity system"
  homepage "http://kin.klever.net/libopkele/"
  revision 1

  stable do
    url "http://kin.klever.net/dist/libopkele-2.0.4.tar.bz2"
    sha256 "102e22431e4ec6f1f0baacb6b1b036476f5e5a83400f2174807a090a14f4dc67"

    # Fix argument-lookup failure on gcc 4.7.1
    patch do
      url "https://github.com/hacker/libopkele/commit/9ff6244998b0d41e71f7cc7351403ad590e990e4.diff"
      sha256 "381b5533a2704a96f0be9ddec16afbc2b853240084168ff40c04dcb34417b9a3"
    end
  end

  bottle do
    cellar :any
    sha256 "57dbb32ce8982e2ad8135917ac1794933edf92b8e2514c16a016bccaaaa1c6aa" => :yosemite
    sha256 "142d206a9bde1877b84e1206fc0b49c6fa47577510b9b22d8d9d07cf385c54bf" => :mavericks
    sha256 "87db53d167b5954fea2eaf8fd3a3d051a4fc23494aa1b606d94aabbd2152f4c0" => :mountain_lion
  end

  head do
    url "https://github.com/hacker/libopkele.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-docs", "Build and install documentation"

  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "openssl"

  # It rejects the tr1/memory that ships on 10.9 & above
  # and refuses to compile. It can use Boost, per configure.
  depends_on "boost" if MacOS.version > :mountain_lion

  def install
    system "./autogen.bash" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    if build.with? "docs"
      system "make", "dox"
      doc.install "doxydox/html"
    end
  end
end
