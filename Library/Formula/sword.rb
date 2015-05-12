class Sword < Formula
  homepage "http://www.crosswire.org/sword/index.jsp"
  url "http://www.crosswire.org/ftpmirror/pub/sword/source/v1.7/sword-1.7.4.tar.gz"
  sha256 "995da8cf5a207c1f09809bf4b9db0bd7d267da5fcdb9d6666c9b313edd9d213d"

  bottle do
    sha1 "8fc45d81b7fcc7d1feffdc130f6c139ffc382db4" => :yosemite
    sha1 "148fd1c7b4358bb3f97979022f65b113afabb856" => :mavericks
    sha1 "36eedc14308de364ebfb1e2fecfc86852b65e3cf" => :mountain_lion
  end

  depends_on "clucene" => :optional
  depends_on "icu4c" => :optional
  option "with-clucene", "Use clucene for text searching capabilities"
  option "with-icu4c", "Use icu4c for unicode support"

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-profile",
      "--disable-tests",
      "--with-curl", # use system curl
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
