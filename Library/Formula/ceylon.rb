class Ceylon < Formula
  desc "Programming language for writing large programs in teams"
  homepage "http://ceylon-lang.org/"
  url "http://ceylon-lang.org/download/dist/1_2_2"
  sha256 "68a7d56b2d3eca83f8832ef1a2e0e58124a71c3c9fc0cda7c377e4882b4feedb"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    man1.install Dir["doc/man/man1/*"]
    doc.install Dir["doc/*"]
    libexec.install Dir["*"]

    # Symlink shell scripts but not *.plugin
    bin.install_symlink "#{libexec}/bin/ceylon"
    bin.install_symlink "#{libexec}/bin/ceylon-sh-setup"
  end

  test do
    ENV.java_cache

    cd "#{libexec}/samples/helloworld" do
      system "#{bin}/ceylon", "compile", "--out", "#{testpath}/modules", "--encoding", "UTF-8", "com.example.helloworld"
      system "#{bin}/ceylon", "doc", "--out", "#{testpath}/modules", "--encoding", "UTF-8", "--non-shared", "com.example.helloworld"
      system "#{bin}/ceylon", "run", "--rep", "#{testpath}/modules", "com.example.helloworld/1.0", "John"
    end
  end
end
