require "formula"

class UniversalNpm < Requirement
  fatal true
  satisfy { which("npm") }
  def message
    "npm is required. If you have installed node with `--without-npm` option, reinstall with `--with-npm`."
  end
end

class Skinny < Formula
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/1.3.6/skinny-1.3.6.tar.gz"
  sha1 "f7403c1c4287a820c42ae55b67d852ae2bd90e99"

  depends_on "node"
  depends_on UniversalNpm

  option "without-npm-generator", "Yeoman generator will not be installed"

  def install
    libexec.install Dir["*"]
    (bin/"skinny").write <<-EOS.undent
      #!/bin/bash
      export PATH=#{bin}:$PATH
      PREFIX="#{libexec}" exec "#{libexec}/skinny" "$@"
    EOS
  end

  def post_install
    return if build.without? "npm-generator"

    cd libexec
    system "npm", "install", "yo"
    ln_s libexec/"node_modules/yo/cli.js", bin/"yo"
    system "npm", "install", "generator-skinny"
  end

  test do
    system bin/"skinny", "new", "myapp"
  end
end
