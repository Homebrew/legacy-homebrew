class Crystal < Formula
  desc "Code generator for every language, library and framework"
  homepage "http://crystal.sh"
  url "https://github.com/crystal/crystal/archive/v0.5.1.tar.gz"
  sha256 "6c022ad59a10cec58856dba858a030b745333909108c08bd326c20ac0cb144fb"

  depends_on "node"

  def install
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"
    ENV["HOME"] = "#{buildpath}/.brew_home"

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
