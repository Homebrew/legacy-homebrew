require 'formula'

class Tomcat < Formula
  homepage 'http://tomcat.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.50/bin/apache-tomcat-7.0.50.tar.gz'
  sha1 '5f8d82b6f142a7b4936680a6bd774bb7330b862e'

  option "with-fulldocs", "Install full documentation locally"

  devel do
    url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.3/bin/apache-tomcat-8.0.3.tar.gz'
    sha1 'f98f796c17c7653fc6bceac8be049df1e2bedc4d'

    resource 'fulldocs' do
      url 'http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.3/bin/apache-tomcat-8.0.3-fulldocs.tar.gz'
      version '8.0.3'
      sha1 '3270682abb87d8ec94beabf4ca4952807c6aa6db'
    end
  end

  resource 'fulldocs' do
    url 'http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-7/v7.0.50/bin/apache-tomcat-7.0.50-fulldocs.tar.gz'
    version '7.0.50'
    sha1 '86a913223582f7c7e4fbf8d88f89870f5b1fd81b'
  end

  # Keep log folders
  skip_clean 'libexec'

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"

    (share/'fulldocs').install resource('fulldocs') if build.with? 'fulldocs'
  end
end
