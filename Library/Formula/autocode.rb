class Autocode < Formula
  desc "Code automation for every language, library and framework"
  homepage "https://crystal.sh/autocode"
  url "https://github.com/crystal/autocode/archive/v0.20.3.tar.gz"
  sha256 "f82f0fa7a2573d5f939a4821769756719ff98a98b0f1903001ee1e3981b30a23"

  depends_on "node"

  def install
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"

    system "npm", "install"
    libexec.install Dir["*", ".autocode"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".autocode/config.yml").write <<-EOS.undent
      name: test
      version: 0.1.0
      description: test description
      author:
        name: Test User
        email: test@example.com
        url: http://example.com
      copyright: 2015 Test
    EOS
    system bin/"autocode", "build"
  end
end
