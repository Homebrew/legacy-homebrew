class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "http://liblo.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.28/liblo-0.28.tar.gz"
  sha256 "da94a9b67b93625354dd89ff7fe31e5297fc9400b6eaf7378c82ee1caf7db909"

  bottle do
    cellar :any
    revision 2
    sha256 "d81d8b215a608d3bc9d5c125a04243372e9ac8c5b1b627045a30c728f89c1c7a" => :el_capitan
    sha256 "e56f28e422f08467b0db99b6db4771a36cd6dba6f4880e57f993f84c41ee1df9" => :yosemite
    sha256 "26f814026942763e874c480f35f0a3345c2267633d7fbc63cdeef4704dd991a4" => :mavericks
  end

  head do
    url "git://liblo.git.sourceforge.net/gitroot/liblo/liblo"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-ipv6", "Compile with support for ipv6"

  deprecated_option "enable-ipv6" => "with-ipv6"

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-ipv6" if build.with? "ipv6"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end
end
