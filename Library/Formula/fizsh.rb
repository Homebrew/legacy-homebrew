class Fizsh < Formula
  desc "Fish-like front end for ZSH"
  homepage "https://github.com/zsh-users/fizsh"
  head "https://github.com/zsh-users/fizsh", :using => :git

  stable do
    url "https://downloads.sourceforge.net/project/fizsh/fizsh-1.0.8.tar.gz"
    sha256 "3d17933c4773532209f9771221ec1dbb33d11fa4e0fbccc506a38d1b4f2359c7"
  end

  bottle do
    cellar :any
    sha256 "b85d71ce36f57763382353e521c43ceef4598bc571564d0a55797d036d7ab045" => :yosemite
    sha256 "f12cafcbe8c29f058a2b18b1074d782173a640b2c725fe4051a7c80b33c53928" => :mavericks
    sha256 "046c263f3f7acf8a124d65b8cdf7c58a871c159480675ec0a8ba37a2183eca37" => :mountain_lion
  end

  depends_on "zsh"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/fizsh -c \"echo hello\"").strip
  end
end
