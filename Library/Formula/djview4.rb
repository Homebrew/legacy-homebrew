class Djview4 < Formula
  desc "Viewer for the DjVu image format"
  homepage "http://djvu.sourceforge.net/djview4.html"
  url "https://downloads.sourceforge.net/project/djvu/DjView/4.10/djview-4.10.3.tar.gz"
  sha256 "50b80ecddc5aec03c49882c91b3af2f42abfe8454d5ddc01fb313e3481e6ab25"

  bottle do
    sha256 "5290a8aef17bd16879e382315d0aa34585ddcbf0512315a2829f299ecb26a08a" => :yosemite
    sha256 "b0f55aae6abd6d7a16ea2b16ad6ee34d695558a4093847693f02a5f26a52e28a" => :mavericks
    sha256 "62b602b5145f8f69f63c9b16e7b7c740d261bd6a17e3b03799b06aceb5701c0d" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "djvulibre"
  depends_on "qt"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-x=no",
                          "--disable-nsdejavu",
                          "--disable-desktopfiles"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"

    # From the djview4.8 README:
    # Note3: Do not use command "make install".
    # Simply copy the application bundle where you want it.
    prefix.install "src/djview.app"
  end
end
