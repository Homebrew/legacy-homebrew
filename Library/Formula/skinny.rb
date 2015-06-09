class Skinny < Formula
  desc "Full-stack web app framework built on Scalatra"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/1.3.18/skinny-1.3.18.tar.gz"
  sha256 "03551f3d87d85bbd0ab5ec1279c8ef62db3588921fe6ffca88892a4c896715d1"

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
