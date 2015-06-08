require 'formula'

class Ceylon < Formula
  desc "Programming language for writing large programs in teams"
  homepage 'http://ceylon-lang.org/'
  url 'http://ceylon-lang.org/download/dist/1_1_0'
  sha1 '91d84e96f3a4468cc2e7de5a4003d5e945bd7c20'

  depends_on :java => "1.7"

  def install
    rm_f Dir["bin/*.bat"]

    man1.install Dir['doc/man/man1/*']
    doc.install Dir['doc/*']
    libexec.install Dir['*']

    # Symlink shell scripts but not args.sh
    bin.install_symlink Dir["#{libexec}/bin/ceylon*"]
  end

  test do
    cd "#{libexec}/samples/helloworld" do
      system "#{bin}/ceylon", "compile", "--encoding", "UTF-8", "com.example.helloworld"
      system "#{bin}/ceylon", "doc", "--encoding", "UTF-8", "--non-shared", "com.example.helloworld"
      system "#{bin}/ceylon", "run", "com.example.helloworld/1.1.0", "John"
    end
  end
end
