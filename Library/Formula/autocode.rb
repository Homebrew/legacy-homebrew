class Autocode < Formula
  desc "Code automation for every language, library and framework"
  homepage "https://autocode.run"
  url "https://github.com/ctate/autocode/archive/v1.1.4.tar.gz"
  sha256 "a86dffccf34503d06d9b6d8f0562eff26616a1b7899bd26a24a06c7d424d2ac2"

  bottle do
    cellar :any_skip_relocation
    sha256 "014e7875b0366e7ba2236b5ddee21e1bb70a4455194b812983c253e7aef8850d" => :el_capitan
    sha256 "53706c84cd49daee1da97474559990f4b73c8ddee62967d59e435d8e6f94321b" => :yosemite
    sha256 "b30ad165254fda87c034be334a42dd6c13fac15243a86f04adc48d9f4ce63965" => :mavericks
  end

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
        url: https://example.com
      copyright: 2015 Test
    EOS
    system bin/"autocode", "build"
  end
end
