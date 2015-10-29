class Ceylon < Formula
  desc "Programming language for writing large programs in teams"
  homepage "http://ceylon-lang.org/"
  url "http://ceylon-lang.org/download/dist/1_2_0"
  sha256 "2e3b50e3e80ea3a356d0d62a2cff5b59104c591aa06387e55cd34a10d52c2919"

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
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{testpath}"
    cd "#{libexec}/samples/helloworld" do
      system "#{bin}/ceylon", "compile", "--out", "#{testpath}/modules", "--encoding", "UTF-8", "com.example.helloworld"
      system "#{bin}/ceylon", "doc", "--out", "#{testpath}/modules", "--encoding", "UTF-8", "--non-shared", "com.example.helloworld"
      system "#{bin}/ceylon", "run", "--rep", "#{testpath}/modules", "com.example.helloworld/1.2.0", "John"
    end
  end
end
