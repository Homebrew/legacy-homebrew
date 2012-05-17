require 'formula'

class Ceylon < Formula
  homepage 'http://ceylon-lang.org/'
  url 'http://ceylon-lang.org/download/dist/1_0_Milestone2'
  version '0.2'
  md5 'ae52a9bb0bac65f36e783121df049e55'

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
      system "#{bin}/ceylond", "-non-shared", "com.acme.helloworld"
      system "#{bin}/ceylon", "com.acme.helloworld/1.0.0", "John"
    end
  end
end
