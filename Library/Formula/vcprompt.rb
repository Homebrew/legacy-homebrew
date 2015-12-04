class Vcprompt < Formula
  desc "Provide version control info in shell prompts"
  homepage "https://bitbucket.org/gward/vcprompt"
  url "https://bitbucket.org/gward/vcprompt/downloads/vcprompt-1.2.1.tar.gz"
  sha256 "98c2dca278a34c5cdbdf4a5ff01747084141fbf4c50ba88710c5a13c3cf9af09"

  bottle do
    cellar :any
    sha256 "cb8fad1d2c10dbf0f70da66714dc2f2db283a6045a323aae0a5f595e4816072e" => :mavericks
    sha256 "d6673b03417a09e2ada451d5440c2e550d6790d79dea2b68d482d0115af467e8" => :mountain_lion
    sha256 "843ca2d2b549d26cf54fbbbba88ef6db71bc1d84c10b08df19d9e2941ad39704" => :lion
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
