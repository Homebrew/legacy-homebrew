require "formula"

class JasmineNode < Formula
  homepage "https://github.com/mhevery/jasmine-node"
  url "https://github.com/mhevery/jasmine-node/archive/1.14.5.tar.gz"
  sha1 "d4f4776476a114ba6a1d0d368cdb4988d39e4cf0"

  depends_on "node"

  def install
    system "#{HOMEBREW_PREFIX}/bin/npm", "install", "--production"
    prefix.install "bin", "lib", "node_modules"
  end

  test do
    (testpath/"jasmine-node.spec.js").write <<-EOS.undent
      describe("test", function() {
        it("something simple", function() {
          expect(1).toEqual(1);
        });
      });
    EOS
    system "#{bin}/jasmine-node", "jasmine-node.spec.js"
  end
end
