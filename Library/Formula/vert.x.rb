class VertX < Formula
  desc "Tool-kit for building reactive applications on the JVM."
  homepage "http://vertx.io/"
  url "https://dl.bintray.com/vertx/downloads/vert.x-3.2.0-full.tar.gz"
  sha256 "10862d825022908f793fc31f88f08a3ba95598db4d89046a48070c0ccc11e044"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf lib]
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
