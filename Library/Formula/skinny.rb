class Skinny < Formula
  desc "Full-stack web app framework built on Scalatra"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/1.3.19/skinny-1.3.19.tar.gz"
  sha256 "a130086dfacc1719b25871c01a1bf27daeffe27a54940e8d3d90eee79868b29b"

  bottle do
    cellar :any
    sha256 "b4c935695d70c76e939cd5d37d3fb3fe631a6e5bc0ef93be7ef12bb2c66c5854" => :yosemite
    sha256 "e24d6147aec3faeff41a1147f4fa0c3b646e4f321b7459943eef7eacfdcf4117" => :mavericks
    sha256 "925d1f6bf905805e98d5d316de2baff5f0258928d3db0cffc6bb7592ba6e0667" => :mountain_lion
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
