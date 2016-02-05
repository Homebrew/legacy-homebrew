class Sword < Formula
  desc "Cross-platform tools to write Bible software"
  homepage "http://www.crosswire.org/sword/index.jsp"
  url "http://www.crosswire.org/ftpmirror/pub/sword/source/v1.7/sword-1.7.4.tar.gz"
  sha256 "995da8cf5a207c1f09809bf4b9db0bd7d267da5fcdb9d6666c9b313edd9d213d"

  bottle do
    revision 1
    sha256 "a6740601f8541d911a5227942008078ce1775052c517213b34ad764a0f3f3af5" => :el_capitan
    sha256 "25f96b8b873f291a3d4101838c6f796f6402641016bfa932d6a90cf310f27492" => :yosemite
    sha256 "565501984e64d06ceb44c0661309f684efb06382349e6ea33e0c5b4749b9fc2b" => :mavericks
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
