class Sword < Formula
  desc "Cross-platform tools to write Bible software"
  homepage "http://www.crosswire.org/sword/index.jsp"
  url "http://www.crosswire.org/ftpmirror/pub/sword/source/v1.7/sword-1.7.4.tar.gz"
  sha256 "995da8cf5a207c1f09809bf4b9db0bd7d267da5fcdb9d6666c9b313edd9d213d"

  bottle do
    sha256 "32082db01516b786bf2477f452b3b2ed1ee927a5042d7ca7ac41209256b7897e" => :yosemite
    sha256 "cf3fe45d1bc967773d39abfe60e19b8df8d9797d1d033a2b5f7993e87aa6834e" => :mavericks
    sha256 "07751178c42bcfe1c668bfd3f5f6c10bea4040f92d75f09fd42947d49f61c5ed" => :mountain_lion
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
