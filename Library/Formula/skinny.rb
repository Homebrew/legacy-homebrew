class Skinny < Formula
  desc "Full-stack web app framework built on Scalatra"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/1.3.18/skinny-1.3.18.tar.gz"
  sha256 "03551f3d87d85bbd0ab5ec1279c8ef62db3588921fe6ffca88892a4c896715d1"

  bottle do
    cellar :any
    sha256 "ee2dcfdd576d69810a50176c9b879b1f567e600edc3e892b0bb9dcbaca72763d" => :yosemite
    sha256 "0b93e3d12480db7a506129d71e0ed74198eec08ee2ad363bef6c2cacc30ca396" => :mavericks
    sha256 "54dda9c068592af2c27c77ba38049d64119c78a5c2a7c7ab722d248473f0394a" => :mountain_lion
  end

  option "without-npm-generator", "Yeoman generator will not be installed"

  depends_on "node"

  def install
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"
    ENV["HOME"] = buildpath/".brew_home"

    if build.with? "npm-generator"
      system "npm", "install", "yo"
      system "npm", "install", "generator-skinny"
      libexec.install Dir["*"]
      bin.install_symlink libexec/"node_modules/yo/lib/cli.js" => "yo"
    else
      libexec.install Dir["*"]
    end

    (bin/"skinny").write <<-EOS.undent
      #!/bin/bash
      export PATH=#{bin}:$PATH
      PREFIX="#{libexec}" exec "#{libexec}/skinny" "$@"
    EOS
  end

  test do
    system bin/"skinny", "new", "myapp"
  end
end
