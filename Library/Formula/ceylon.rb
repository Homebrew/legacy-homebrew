class Ceylon < Formula
  desc "Programming language for writing large programs in teams"
  homepage "http://ceylon-lang.org/"
  url "http://ceylon-lang.org/download/dist/1_2_1"
  sha256 "08379f76e5ce2db01f015efbfde05ecc7c8a8244441459eb7c4ea830eabaa1bb"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    rm_f Dir["bin/*.bat"]

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
      system "#{bin}/ceylon", "run", "--rep", "#{testpath}/modules", "com.example.helloworld/1.2.1", "John"
    end
  end
end
