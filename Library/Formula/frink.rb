require 'formula'

class Frink < Formula
  head 'http://futureboy.us/frinkjar/frink.jar'
  homepage 'http://futureboy.us/frinkdocs/index.html'
  md5 'a7db7977a520ea2b54d1166ff0738efc'

  depends_on 'rlwrap'

  def install
    prefix.install 'frink.jar'

    # Add an executable shell-script
    (bin + "frink").write <<-EOF.undent
      #!/bin/sh
      rlwrap java -cp #{prefix}/frink.jar frink.parser.Frink \"$@\"
    EOF
  end
end
