require 'formula'

class Ceylon < Formula
  homepage 'http://ceylon-lang.org/'
  url 'http://ceylon-lang.org/download/dist/1_0_Milestone1'
  version '1.0.M1'
  md5 '627ebfc52fc9ba93fc63df59f8309509'

  def install
    rm_f Dir["bin/*.bat"]

    doc.install Dir['doc/*']
    libexec.install Dir['*']

    # Symlink shell scripts but not args.sh
    bin.install_symlink Dir["#{libexec}/bin/ceylon*"]
  end

  def test
    cd "#{libexec}/samples/helloworld" do
      system "#{bin}/ceylonc", "com.acme.helloworld"
      system "#{bin}/ceylond", "-private", "com.acme.helloworld"
      system "#{bin}/ceylon", "com.acme.helloworld/1.0.0", "John"
    end
  end
end
