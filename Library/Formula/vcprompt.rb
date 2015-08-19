class Vcprompt < Formula
  desc "Provide version control info in shell prompts"
  homepage "https://bitbucket.org/gward/vcprompt"
  url "https://bitbucket.org/gward/vcprompt/downloads/vcprompt-1.2.1.tar.gz"
  sha256 "98c2dca278a34c5cdbdf4a5ff01747084141fbf4c50ba88710c5a13c3cf9af09"

  bottle do
    cellar :any
    sha1 "609b05ec156a7b5b154150800dfefd1adcbef0df" => :mavericks
    sha1 "b20758412be3d8abc8d99a055f34da5c94861280" => :mountain_lion
    sha1 "f7618134adfd9bd57011eabd66278f8c8918fca0" => :lion
  end

  head do
    url "https://bitbucket.org/gward/vcprompt", :using => :hg
    depends_on "autoconf" => :build
  end

  depends_on "sqlite"

  def install
    system "autoconf" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    system "#{bin}/vcprompt"
  end
end
