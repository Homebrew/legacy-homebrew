class Crystal < Formula
  desc "Code generator for every language, library and framework"
  homepage "http://crystal.sh"
  url "https://github.com/crystal/crystal/archive/v0.5.1.tar.gz"
  sha256 "6c022ad59a10cec58856dba858a030b745333909108c08bd326c20ac0cb144fb"

  bottle do
    cellar :any
    sha256 "5586dc0d8f07d3b81446e7de9e0fd115fa46e59e7d220931977b5c4c4cf94031" => :yosemite
    sha256 "d5bf22cc553e0c5b61d7775a53aab0f6be51d0e2eeea8c9352ddbc614dbebad5" => :mavericks
    sha256 "62c0f7937b94d9cd9e2d80a99794d49886a0867c92faae90e915370165a8856b" => :mountain_lion
  end

  depends_on "node"

  def install
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"

    system "npm", "install"
    libexec.install Dir["*", ".crystal"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".crystal/config.yml").write <<-EOS.undent
      name: test
      version: 0.1.0
      description: test description
      author:
        name: Test User
        email: test@example.com
        url: http://example.com
      copyright: 2015 Test
    EOS
    system bin/"crystal", "build"
  end
end
