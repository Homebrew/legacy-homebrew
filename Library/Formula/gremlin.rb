require 'formula'

class Gremlin < Formula
  homepage 'http://gremlin.tinkerpop.com/'
  url 'https://github.com/downloads/tinkerpop/gremlin/gremlin-1.3.zip'
  md5 'c524ee20e119c3b6059cfd0b7873d94c'

  head 'https://github.com/tinkerpop/gremlin.git'

  depends_on 'maven' if build.head?

  def install
    # If this is a head build, checkout the source and build it with maven
    if build.head?

      # Setup a couple of paths for the build
      pwd = Pathname.new('.')
      m2 = pwd+'.m2'

      # Create a local settings file to make sure that all cached downloads
      # are saved in a local repository which will be deleted once the build
      # is complete.
      (pwd+'settings.xml').write <<-EOF.undent
        <?xml version="1.0" encoding="UTF-8"?>
        <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 \
              http://maven.apache.org/xsd/settings-1.0.0.xsd">
          <localRepository>#{m2}</localRepository>
        </settings>
      EOF

      # Perform the build
      system 'mvn clean install -s ./settings.xml'
    end

    target = Pathname.glob('./target/gremlin-*-standalone')[0]
    libexec.install Dir[target+'lib'+'*.jar']
    inreplace target+'bin'+'gremlin.sh', '`dirname $0`/../lib', libexec
    bin.install target+'bin'+'gremlin.sh' => 'gremlin'
  end
end
