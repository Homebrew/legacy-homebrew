class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/2.0.6/skinny-2.0.6.tar.gz"
  sha256 "30d77ab22efd8dbf4d7b353eb90060ef32f61d71efd8f228451d6549d57675c0"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
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
