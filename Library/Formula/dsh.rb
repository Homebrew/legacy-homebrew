class Dsh < Formula
  desc "Dancer's shell, or distributed shell"
  homepage "http://www.netfort.gr.jp/~dancer/software/dsh.html.en"
  url "http://www.netfort.gr.jp/~dancer/software/downloads/dsh-0.25.9.tar.gz"
  sha256 "147c59c902dbd7a3290e20f41b5cc594192d6c93957d34dd061eb8d27bd9e466"

  depends_on "libdshconfig"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
