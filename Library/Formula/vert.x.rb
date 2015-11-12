class VertX < Formula
  desc "Application platform for the JVM"
  homepage "http://vertx.io/"
  url "https://dl.bintray.com/vertx/downloads/vert.x-3.1.0-full.tar.gz"
  sha256 "292eadeb7df7e3947142b8860d0088b2bfecd83d81e1cb9c9b2e5e79fde5731b"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin client conf lib]
    bin.install_symlink "#{libexec}/bin/vertx"
  end

  test do
    (testpath/"HelloWorld.java").write <<-EOS.undent
    import io.vertx.core.AbstractVerticle;
    public class HelloWorld extends AbstractVerticle {
      public void start() {
        System.out.println("Hello World!");
        vertx.close();
        System.exit(0);
      }
    }
    EOS
    system "#{bin}/vertx", "run", "HelloWorld.java"
  end
end
