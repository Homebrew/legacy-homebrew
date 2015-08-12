class Csmith < Formula
  desc "Generates random C programs conforming to the C99 standard"
  homepage "https://embed.cs.utah.edu/csmith/"
  url "https://embed.cs.utah.edu/csmith/csmith-2.2.0.tar.gz"
  sha256 "62fd96d3a5228241d4f3159511ad3ff5b8c4cedb9e9a82adc935830b421c8e37"

  bottle do
    cellar :any
    sha256 "38f7cf4e3e01431a0b2a32aa723f6862490c5f5580b389d4bad84287c1ff068e" => :el_capitan
    sha256 "66393d59fae564c88c0040f6d117d7dc5b50400614f1c0b9e235cb54053fe159" => :yosemite
    sha256 "365711b325bf93d13b6c6c6c430a7b136f4e2962ea18814213911c204db71d37" => :mavericks
    sha256 "92fbb0c44e5cb1042c22aae462acf6afc22a568b7b446dbccaecb5bbd07b0921" => :mountain_lion
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
