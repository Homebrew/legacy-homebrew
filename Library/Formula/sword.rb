class Sword < Formula
  desc "Cross-platform tools to write Bible software"
  homepage "https://www.crosswire.org/sword/index.jsp"
  url "https://www.crosswire.org/ftpmirror/pub/sword/source/v1.7/sword-1.7.4.tar.gz"
  sha256 "995da8cf5a207c1f09809bf4b9db0bd7d267da5fcdb9d6666c9b313edd9d213d"

  bottle do
    revision 2
    sha256 "7b9581c869aa590288ad5b076b2547bcfe4edcb869550fc2c97497bcbb83e7ec" => :el_capitan
    sha256 "1c5b77b0a2d5441cd9a51a72c65d8c64b64840072b70eb34a4c0231e7fe35c48" => :yosemite
    sha256 "dc3bd07b3621d61ab58c1f1ca9796d7b1af05e3fccee3f8181cb5c743642df29" => :mavericks
  end

  option "with-clucene", "Use clucene for text searching capabilities"
  option "with-icu4c", "Use icu4c for unicode support"

  depends_on "clucene" => :optional
  depends_on "icu4c" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-profile
      --disable-tests
      --with-curl
    ]

    if build.with? "icu4c"
      args << "--with-icu"
    else
      args << "--without-icu"
    end

    if build.with? "clucene"
      args << "--with-clucene"
    else
      args << "--without-clucene"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    # This will call sword's module manager to list remote sources.
    # It should just demonstrate that the lib was correctly installed
    # and can be used by frontends like installmgr.
    system "#{bin}/installmgr", "-s"
  end
end
