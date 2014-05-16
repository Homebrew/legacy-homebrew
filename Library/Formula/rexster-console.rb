require "formula"

class RexsterConsole < Formula
  homepage "https://github.com/tinkerpop/rexster/wiki"
  url "http://tinkerpop.com/downloads/rexster/rexster-console-2.5.0.zip"
  sha1 "0243908c0ab65baea4b8092bb2b818c597622187"

  def install
    libexec.install %w[lib doc]
    (libexec/"ext").mkpath
    (libexec/"bin").mkpath
    (libexec/"bin").install "bin/rexster-console.sh" => "rexster-console"
    bin.install_symlink libexec/"bin/rexster-console"

    inreplace "#{libexec}/bin/rexster-console",
      "CP=\$( echo `dirname \$0`/../lib/*.jar . | sed 's/ /:/g')
CP=$CP:$( echo `dirname $0`/../ext/*.jar . | sed 's/ /:/g')
#echo $CP",
      "# From: http://stackoverflow.com/a/246128
#   - To resolve finding the directory after symlinks
SOURCE=\"${BASH_SOURCE[0]}\"
# resolve $SOURCE until the file is no longer a symlink
while [ -h \"$SOURCE\" ]; do
  DIR=\"$( cd -P \"$( dirname \"$SOURCE\" )\" && pwd )\"
  SOURCE=\"$(readlink \"$SOURCE\")\"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE=\"$DIR/$SOURCE\"
done
DIR=\"$( cd -P \"$( dirname \"$SOURCE\" )\" && pwd )\"

CP=$( echo \"$DIR\"/../lib/*.jar . | sed 's/ /:/g')
CP=$CP:$( echo \"$DIR\"/../ext/*.jar . | sed 's/ /:/g')"
  end

  test do
    system "#{bin}/rexster-console", "-h"
  end
end
