class Antlr < Formula
  desc "ANTLR: ANother Tool for Language Recognition"
  homepage "http://www.antlr.org/"
  url "http://www.antlr.org/download/antlr-4.5.1-complete.jar"
  sha256 "9cff6c76bc5aafcbf51cac7f0974ae01e4f6119402e75436abbb97f8ab15c211"

  def install
    prefix.install "antlr-#{version}-complete.jar"
    bin.write_jar_script prefix/"antlr-#{version}-complete.jar", "antlr4"
    (bin+"grun").write <<-EOS.undent
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
