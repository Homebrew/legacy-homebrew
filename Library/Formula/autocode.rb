class Autocode < Formula
  desc "Code automation for every language, library and framework"
  homepage "https://autocode.run"
  url "https://github.com/ctate/autocode/archive/v1.3.1.tar.gz"
  sha256 "a263353a3ff63bd0cf7606335e453f40caa76abd783957ac4feb8b793f1751bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "406f503777d7335cc815bfc4281a736aa0b93538ed3b52211f8ec819e85267da" => :el_capitan
    sha256 "25bbae994afdf3383fd2009881f09afb2adda58ae9f2803e43a1230fbd0eb19d" => :yosemite
    sha256 "1d7dfd2af3332f0048458ce250c1d98caefc7cb77718e74a0646ae233ee3e468" => :mavericks
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
