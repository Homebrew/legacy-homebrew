class ProcyonDecompiler < Formula
  desc "Modern decompiler for Java 5 and beyond."
  homepage "https://bitbucket.org/mstrobel/procyon/wiki/Java%20Decompiler"
  url "https://bitbucket.org/mstrobel/procyon/downloads/procyon-decompiler-0.5.30.jar"
  sha256 "cd9a2177f72f490842b0b84909f58b5548614a78ecd135ce28b833f93429e5a0"

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
