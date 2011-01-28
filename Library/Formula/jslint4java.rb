require 'formula'

class Jslint4java <Formula
  version '1.4.6'
  url "http://jslint4java.googlecode.com/files/jslint4java-#{version}-dist.zip"
  homepage 'http://code.google.com/p/jslint4java/'
  md5 '5cde5cb0d34c78d21ec19e7ffd6afc9c'

  def install
  	prefix.install Dir['*']
  	bin.mkpath
	(bin + 'jslint4java').write <<-EOF
#!/bin/bash
java -jar #{prefix}/jslint4java-#{version}.jar "$@"
EOF
  end
end
