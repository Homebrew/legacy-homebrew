require 'formula'

class Plantuml <Formula
  url 'http://downloads.sourceforge.net/project/plantuml/plantuml.jar'
  homepage 'http://plantuml.sourceforge.net/'
  md5 '82960534c35cf5c57ff653e47fcbea72'
  version '1.0'

  def jar
    'plantuml.jar'
  end

  def script
<<-EOS
#!/bin/sh
## Runs plantuml
## With no arguments, runs Clojure's REPL.
#
PLANTUML=$(brew --cellar)/#{name}/#{version}/#{jar}

java -jar $PLANTUML "$@"
EOS
  end

  def install
    prefix.install jar
    (bin+'plantuml').write script
  end
end
