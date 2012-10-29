require 'formula'

class Ceylon < Formula
  homepage 'http://ceylon-lang.org/'
  url 'http://ceylon-lang.org/download/dist/1_0_Milestone4'
  version '1.0M4'
  sha1 '0d4bb339759d9f0d55da1a89d87a13b160e51163'

  def install
    rm_f Dir["bin/*.bat"]

    doc.install Dir['doc/*']
    libexec.install Dir['*']

    # Symlink shell scripts but not args.sh
    bin.install_symlink Dir["#{libexec}/bin/ceylon*"]
  end

  def caveats
    "Ceylon requires Java 7."
  end

  def test
    cd "#{libexec}/samples/helloworld" do
      system "#{bin}/ceylon", "compile", "com.acme.helloworld"
      system "#{bin}/ceylon", "doc", "--non-shared", "com.acme.helloworld"
      system "#{bin}/ceylon", "run", "com.acme.helloworld/1.0.0", "John"
    end
  end
end
