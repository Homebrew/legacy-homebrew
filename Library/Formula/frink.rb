require 'formula'

class Frink <Formula
  version '2010.11.06' # It has no version number, using last date reported
  url 'http://futureboy.us/frinkjar/frink.jar'
  homepage 'http://futureboy.us/frinkdocs/index.html'
  md5 '00ce4fa06744f052cca11f3f1c88ca9f'
  depends_on 'rlwrap'

  def jar
    'frink.jar'
  end

  def install
    prefix.install "frink.jar"
    # Add an executable shell-script
    (bin + "frink").write "#!/bin/sh\nrlwrap java -cp #{prefix}/#{jar} frink.parser.Frink \"$@\""
  end
end