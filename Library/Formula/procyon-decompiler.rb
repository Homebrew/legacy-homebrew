class ProcyonDecompiler < Formula
  desc "Modern decompiler for Java 5 and beyond."
  homepage "https://bitbucket.org/mstrobel/procyon/wiki/Java%20Decompiler"
  url "https://bitbucket.org/mstrobel/procyon/downloads/procyon-decompiler-0.5.29.jar"
  sha256 "51574860851c3ff13b5c3ca455d862f2868c32ba3ab786069b4312ffd6c6b2a8"

  depends_on :java => "1.7+"

  def install
    libexec.install "procyon-decompiler-#{version}.jar"
    bin.write_jar_script libexec/"procyon-decompiler-#{version}.jar", "procyon-decompiler"
  end

  test do
    fixture = <<-EOS.undent
    class T
    {
        public static void main(final String[] array) {
            System.out.println("Hello World!");
        }
    }
    EOS
    (testpath/"T.java").write fixture
    system "javac", "T.java"
    fixture.match pipe_output("#{bin}/procyon-decompiler", "T.class")
  end
end
