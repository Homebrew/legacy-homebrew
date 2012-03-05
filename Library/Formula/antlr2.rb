require 'formula'

class Antlr2 < Formula

  homepage 'http://www.antlr2.org'
  url 'http://www.antlr2.org/download/antlr-2.7.7.tar.gz'
  md5 '01cc9a2a454dd33dcd8c856ec89af090'

  def install

    args = ["--prefix=#{prefix}"]

    system "./configure", *args
    system "make"

    prefix.install "antlr.jar"
    include.install "lib/cpp/antlr"
    lib.install "lib/cpp/src/libantlr.a"
    (bin+"antlr2").write <<-EOS.undent
    #!/bin/sh
    java -classpath #{prefix}/antlr.jar antlr.Tool "$@"
    EOS
  end

end
