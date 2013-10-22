require 'formula'

class Ceylon < Formula
  homepage 'http://ceylon-lang.org/'
  url 'http://ceylon-lang.org/download/dist/1_0_Beta'
  version '1.0.beta'
  sha1 'a84e7684545fac8751aa7538a47accf36708e5e7'

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
