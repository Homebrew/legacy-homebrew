class Skinny < Formula
  desc "Full-stack web app framework built on Scalatra"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/1.3.20/skinny-1.3.20.tar.gz"
  sha256 "b47d3df42fa9b54c77e72bd921261131b565a51a0e4578acac699a83c7365233"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1e2dd61a6e1ee7baf9bace68908c0cc81fbec4fc5a72841b1eec34be8e05ddf" => :el_capitan
    sha256 "d111d7e0cd3a6c8d759a3eeb2a4039f186c79b4a2ae69458dff3eeef773d9364" => :yosemite
    sha256 "3f5fe80d9a51b7f7b9c82d0e547ca26933d9ce9be3f15fa3ad24c62dd5436f42" => :mavericks
    sha256 "9ae8759b4feef01177fcfda6c84f450a028bc71a4bb3de6a413a8105e99b87e7" => :mountain_lion
  end

  option "without-npm-generator", "Yeoman generator will not be installed"

  depends_on "node"

  def install
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"

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
