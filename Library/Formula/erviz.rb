require 'formula'

class Erviz < Formula
  url 'http://dl.dropbox.com/u/10466872/Erviz/erviz-1.0.6-bin.zip'
  homepage 'http://www.ab.auone-net.jp/~simply/en/works/erviz/about.html'
  md5 'dbfa20515118535c106032c8200163c6'

  depends_on 'graphviz'

  def install
    libexec.install Dir["_setup_/common/bin/*.jar"]

    (bin+'erviz').write <<-EOS.undent
      #!/bin/sh
      java -Duser.language=en -Duser.country=US -cp "#{libexec}/erviz-cui-1.0.6.jar:#{libexec}/erviz-core-1.0.6.jar" jp.gr.java_conf.simply.erviz.cui.Main "$@"
    EOS
  end
end
