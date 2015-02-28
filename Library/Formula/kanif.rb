class Kanif < Formula
  homepage "http://taktuk.gforge.inria.fr/kanif/"
  url "http://gforge.inria.fr/frs/download.php/26773/kanif-1.2.2.tar.gz"
  sha1 "7a10fe0e74159875f004b6c4a12a0202ff092ce9"

  depends_on "taktuk" => :run

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "taktuk -s -c 'ssh' -l brew",
      shell_output("#{bin}/kash -q -l brew -r ssh")
  end
end
