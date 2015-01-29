class Fizsh < Formula
  homepage "https://github.com/zsh-users/fizsh"

  stable do
    url "https://downloads.sourceforge.net/project/fizsh/fizsh-1.0.8.tar.gz"
    sha1 "515f8828c8bd9f2da1e2716bb3d60727e2f26e90"
  end

  head "https://github.com/zsh-users/fizsh", :using => :git

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
