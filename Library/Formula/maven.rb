require 'formula'

class Maven <Formula
  url 'http://www.apache.org/dist/maven/binaries/apache-maven-3.0.3-bin.tar.gz'
  homepage 'http://maven.apache.org/'
  md5 '507828d328eb3735103c0492443ef0f0'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, Dir["conf/settings.xml"]

    # Install jars in libexec to avoid conflicts
    prefix.install %w{ NOTICE.txt LICENSE.txt README.txt }
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin+File.basename(f)
    end
  end
end
