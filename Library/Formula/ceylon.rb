require 'formula'

class Ceylon < Formula
  homepage 'http://ceylon-lang.org/'
  url 'http://ceylon-lang.org/download/dist/1_0_Milestone3'
  version '1.0M3'
  sha1 'c25efda8c717da55d92c063dd5414a02aab8ff1d'

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
      system "#{bin}/ceylonc", "com.acme.helloworld"
      system "#{bin}/ceylond", "-non-shared", "com.acme.helloworld"
      system "#{bin}/ceylon", "com.acme.helloworld/1.0.0", "John"
    end
  end
end
