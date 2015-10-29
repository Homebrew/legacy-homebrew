class Autocode < Formula
  desc "Code automation for every language, library and framework"
  homepage "https://autocode.run"
  url "https://github.com/crystal/autocode/archive/v0.21.2.tar.gz"
  sha256 "64eccf7cfcfb361919f2eced326e5dd1fc3545dc6d56465e41e878e029130308"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e6b1f8e8d8253fe64b765f4a013865dc0c1af9078f2a508aef38ed02c568d25" => :el_capitan
    sha256 "59aa8cb817d505efcd4e5301e07a7cac10bf93bc6a21e212088791d3ab4d7815" => :yosemite
    sha256 "9f6432067e34a866daee23079f2a5be6f5bbb6f917792f65027feb8d58ea92f0" => :mavericks
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
