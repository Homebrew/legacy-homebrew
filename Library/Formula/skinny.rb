class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/2.0.0/skinny-2.0.0.tar.gz"
  sha256 "b6bd65abbf61170b2802ca7d7fa27ef8692361ad49982a4269f6752058f79a67"

  bottle do
    cellar :any_skip_relocation
    sha256 "3379b7e2c76d63ce21df61ded15e464562e480ccc8c557b72212c53a8fb3f0db" => :el_capitan
    sha256 "0081a830ddd3c5a968eaf1490cd8bc772e1c3b8ade0dd410494a807f5c583da6" => :yosemite
    sha256 "06542db66377eb3b906859f610a3b8bfc628d07e9d14e006b1ef0cea17645cf4" => :mavericks
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
