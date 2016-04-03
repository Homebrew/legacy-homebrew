class Antlr < Formula
  desc "ANTLR: ANother Tool for Language Recognition"
  homepage "http://www.antlr.org/"
  url "http://www.antlr.org/download/antlr-4.5.2-complete.jar"
  sha256 "23e975fac2c464f4366c50288151d66efc1c13552c123aeb77c9e1e695772e4e"

  bottle :unneeded

  def install
    prefix.install "antlr-#{version}-complete.jar"

    (bin/"antlr4").write <<-EOS.undent
      #!/bin/bash
      CLASSPATH="#{prefix}/antlr-#{version}-complete.jar:." exec java -jar #{prefix}/antlr-#{version}-complete.jar "$@"
    EOS

    (bin/"grun").write <<-EOS.undent
      #!/bin/bash
      java -classpath #{prefix}/antlr-#{version}-complete.jar:. org.antlr.v4.runtime.misc.TestRig "$@"
    EOS
  end

  test do
    path = testpath/"Expr.g4"
    path.write <<-EOS.undent
    grammar Expr;
    prog:\t(expr NEWLINE)* ;
    expr:\texpr ('*'|'/') expr
        |\texpr ('+'|'-') expr
        |\tINT
        |\t'(' expr ')'
        ;
    NEWLINE :\t[\\r\\n]+ ;
    INT     :\t[0-9]+ ;
    EOS
    ENV.prepend "CLASSPATH", "#{prefix}/antlr-#{version}-complete.jar", ":"
    ENV.prepend "CLASSPATH", ".", ":"
    system "#{bin}/antlr4", "Expr.g4"
    system "javac", *Dir["Expr*.java"]
    assert_match(/^$/, pipe_output("#{bin}/grun Expr prog", "22+20\n"))
  end
end
