class Autocode < Formula
  desc "Code automation for every language, library and framework"
  homepage "https://crystal.sh/autocode"
  url "https://github.com/crystal/autocode/archive/v0.20.3.tar.gz"
  sha256 "f82f0fa7a2573d5f939a4821769756719ff98a98b0f1903001ee1e3981b30a23"

  bottle do
    cellar :any_skip_relocation
    sha256 "5aac71c4a2e4f3e084568de4757822c5f1aaa733db7b36a0b187151516499bac" => :el_capitan
    sha256 "686a3de9b0eba6088f4fe2d130e76c75edb4233960db2daa615a8f5b5b99e590" => :yosemite
    sha256 "e613bae16cfbe747f3e7ae43c4e1d34a9cbe736610641063737adfe788897dab" => :mavericks
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
        url: http://example.com
      copyright: 2015 Test
    EOS
    system bin/"autocode", "build"
  end
end
