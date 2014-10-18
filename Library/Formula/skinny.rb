require "formula"

class Skinny < Formula
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/1.3.4/skinny-1.3.4.tar.gz"
  sha1 "79cb32e4ddc579913445e3514cde62bd6ce66546"

  depends_on "node"

  class UniversalNpm < Requirement
    fatal true
    satisfy { which("npm") }
    def message
      "npm is required. If you have installed node with `--without-npm` option, reinstall with `--with-npm`."
    end
  end
  depends_on UniversalNpm

  option "without-npm-generator", "Yeoman generator will not be installed"

  def install
    # npm wrapper only for this skinny script
    (libexec/"npm").write_env_script "npm", :PREFIX => libexec
    chmod 0755, libexec/"npm"

    libexec.install Dir["*"]

    # `skinny new/upgrade` use only its own node_modules under libexec dir
    (bin/"skinny").write <<-EOS.undent
      #!/bin/bash
      export PATH=#{libexec}/bin/:$PATH
      PREFIX="#{libexec}" exec "#{libexec}/skinny" "$@"
    EOS
  end

  def post_install
    # brew install skinny --without-npm-generator
    return if build.without? "npm-generator"

    # install npm modules under libexec dir
    system libexec/"npm", "install", "-g", "yo"
    system libexec/"npm", "install", "-g", "generator-skinny"
  end

  test do
    system bin/"skinny", "new", "myapp"
  end
end
