require 'formula'

class Maven <Formula
  url 'http://www.apache.org/dist/maven/binaries/apache-maven-2.2.1-bin.tar.gz'
  head 'http://www.apache.org/dyn/closer.cgi/maven/binaries/apache-maven-3.0.4-bin.tar.gz'
  homepage 'http://maven.apache.org/'

  if ARGV.build_head?
    md5 'e513740978238cb9e4d482103751f6b7'
  else
    md5 '3f829ed854cbacdaca8f809e4954c916'
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, Dir["conf/settings.xml"]

    prefix.install %w{ NOTICE.txt LICENSE.txt README.txt }
    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
