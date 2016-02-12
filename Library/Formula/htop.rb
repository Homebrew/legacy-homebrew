class Htop < Formula
  desc "Interactive process viewer for Unix"
  homepage "http://hisham.hm/htop/"
  url "http://hisham.hm/htop/releases/2.0.0/htop-2.0.0.tar.gz"
  sha256 "d15ca2a0abd6d91d6d17fd685043929cfe7aa91199a9f4b3ebbb370a2c2424b5"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    pipe_output("#{bin}/htop", "q")
    assert $?.success?
  end
end
