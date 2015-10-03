class Csmith < Formula
  desc "Generates random C programs conforming to the C99 standard"
  homepage "https://embed.cs.utah.edu/csmith/"
  url "https://embed.cs.utah.edu/csmith/csmith-2.2.0.tar.gz"
  sha256 "62fd96d3a5228241d4f3159511ad3ff5b8c4cedb9e9a82adc935830b421c8e37"

  bottle do
    cellar :any
    sha1 "148f6ff8f8bfbca55af569fa6db560e6917c6d98" => :yosemite
    sha1 "98647f884d0e48cf487a47d627c9c66f01aef06e" => :mavericks
    sha1 "551902d606958f2e504103a648b0fcca6edc5e69" => :mountain_lion
  end

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
