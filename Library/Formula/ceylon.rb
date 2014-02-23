require 'formula'

class Ceylon < Formula
  homepage 'http://ceylon-lang.org/'
  url 'http://ceylon-lang.org/download/dist/1_0_0'
  sha1 '24737e1816c16497cb4b504d857530e1a171c2bf'

  def install
    rm_f Dir["bin/*.bat"]

    man1.install Dir['doc/man/man1/*']
    doc.install Dir['doc/*']
    libexec.install Dir['*']

    # Symlink shell scripts but not args.sh
    bin.install_symlink Dir["#{libexec}/bin/ceylon*"]
  end

  def caveats
    "Ceylon requires Java 7."
  end

  test do
    cd "#{libexec}/samples/helloworld" do
      system "#{bin}/ceylon", "compile", "com.acme.helloworld"
      system "#{bin}/ceylon", "doc", "--non-shared", "com.acme.helloworld"
      system "#{bin}/ceylon", "run", "com.acme.helloworld/1.0.0", "John"
    end
  end
end
