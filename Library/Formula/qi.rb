class Qi < Formula
  desc "Functional programming language"
  homepage "http://www.lambdassociates.org/"
  url "http://www.lambdassociates.org/Download/QiII1.07.zip"
  sha256 "515bb99efa1da3f8d416c370c9d98776d273c593efa241dc243da543118fc521"

  bottle do
    cellar :any
    sha256 "b52934ecc91ecffcd08c73180db59084ede6ad301d856681ed4d795e60a4079f" => :yosemite
    sha256 "26d53a5485f8fe56eced34ea9fd86db26d90853fa180a982bb2e59a216ee2e97" => :mavericks
    sha256 "facde8f9c5e8ae39761259769c28733c338d2e97c92a672c7266ac01e2d5b83c" => :mountain_lion
  end

  depends_on "sbcl" => :optional

  deprecated_option "SBCL" => "with-sbcl"

  if build.without? "sbcl"
    depends_on "clisp"
  end

  def install
    if build.with? "sbcl"
      cd "Lisp" do
        system "sbcl", "--load", "install.lsp"
      end

      (bin/"qi").write "#!/bin/bash\nsbcl --core #{prefix}/Qi.core $*"
      prefix.install "Lisp/Qi.core"
    else
      cd "Lisp" do
        system "clisp", "install.lsp"
      end

      (bin/"qi").write "#!/bin/bash\nclisp -M #{prefix}/Qi.mem $*"
      prefix.install "Lisp/Qi.mem"
    end
    chmod 0755, bin/"qi"
  end

  test do
    assert_match(/\(0-\) 42/,
                pipe_output("#{bin}/qi", "(+ 40 1 1)\n(quit)\n", 0))
  end
end
