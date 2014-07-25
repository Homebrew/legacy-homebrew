require "formula"

class Bindfs < Formula
  homepage "http://bindfs.org/"
  url "http://bindfs.org/downloads/bindfs-1.12.6.tar.gz"
  sha1 "2685a2a1a88f5f84d305bd47f058035949bc887a"

  bottle do
    cellar :any
    sha1 "46e3db6e3561d5ba4c199e54e7233aacee361fc8" => :mavericks
    sha1 "e11546dca95a6fb8fd67fb180418a29984021219" => :mountain_lion
    sha1 "cf04d4fd33ba8575c74c53c44a9978cc99b7cd4b" => :lion
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "osxfuse"

  def install
    if build.head?
      system "./autogen.sh", "--disable-debug",
                             "--disable-dependency-tracking",
                             "--prefix=#{prefix}"
    else
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
    end

    system "make install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
