class Crystal < Formula
  desc "Code generator for every language, library and framework"
  homepage "http://crystal.sh"
  url "https://github.com/crystal/crystal/archive/v0.5.1.tar.gz"
  sha256 "6c022ad59a10cec58856dba858a030b745333909108c08bd326c20ac0cb144fb"

  depends_on "node"

  def install
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def post_install
    cd libexec
    system "npm", "install"
  end

  test do
    system bin/"crystal", "help"
  end
end
