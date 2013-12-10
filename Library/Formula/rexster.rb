require 'formula'

class Rexster < Formula
  homepage 'http://rexster.tinkerpop.com'
  url 'http://tinkerpop.com/downloads/rexster/rexster-server-2.4.0.zip'
  sha1 '9fb8d7ac4c797f44bed03d9309479841b5430e50'
  head do
    url 'https://github.com/tinkerpop/rexster.git', :branch => 'master'
    depends_on "maven" => :build
  end
  def patches
    DATA
  end

  def install
    if build.head?
      system 'mvn', 'clean', 'install'
    else
      bin.install 'bin/rexster.sh'
      mv bin/'rexster.sh', bin/'rexster'
      prefix.install 'config', 'data', 'doc', 'ext', 'public'
      libexec.install Dir['lib/*']
    end
  end

  def caveats
    <<-EOS.undent
      NOTE:
      To start rexster, run 'rexster -s -c #{prefix}/config/rexster.xml'
    EOS
  end
end

__END__
diff --git a/bin/rexster.sh b/bin/rexster.sh
--- a/bin/rexster.sh
+++ b/bin/rexster.sh
@@ -1,11 +1,11 @@
 #!/bin/bash
 
-CP=$( echo `dirname $0`/../lib/*.jar . | sed 's/ /:/g')
-CP=$CP:$(find -L `dirname $0`/../ext/ -name "*.jar" | tr '\n' ':')
+CP=$( echo `dirname $(grealpath $0)`/../libexec/*.jar . | sed 's/ /:/g')
+CP=$CP:$(find -L `dirname $(grealpath $0)`/../ext/ -name "*.jar" | tr '\n' ':')

 REXSTER_EXT=../ext
 
-PUBLIC=`dirname $0`/../public/
+PUBLIC=`dirname $(grealpath $0)`/../public/
 EXTRA=
 
 if [ $1 = "-s" ] ; then
