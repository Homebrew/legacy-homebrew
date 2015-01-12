class Csmith < Formula
  homepage "http://embed.cs.utah.edu/csmith/"
  url "http://embed.cs.utah.edu/csmith/csmith-2.2.0.tar.gz"
  sha1 "3435ce22e645977e03cf6418da076ff3f7a1d4f0"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    mv "#{bin}/compiler_test.in", share
    (include/"csmith-#{version}/runtime").install Dir["runtime/*.h"]
  end

  def caveats; <<-EOS.undent
    It is recommended that you set the environment variable 'CSMITH_PATH' to
      #{include}/csmith-#{version}
    EOS
  end

  test do
    system "#{bin}/csmith", "-o", "test.c"
  end
end
