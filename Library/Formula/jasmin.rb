require 'formula'

class Jasmin < Formula
  homepage 'http://jasmin.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/jasmin/jasmin/jasmin-2.4/jasmin-2.4.zip'
  sha1 'c66400680144e0da4efdcf4a084e42e2355189fe'

  def install
    # Remove Windows scripts
    rm_rf Dir['*.bat']

    libexec.install Dir['*.jar']
    prefix.install %w[Readme.txt license-ant.txt license-jasmin.txt]
    bin.write_jar_script libexec/'jasmin.jar', 'jasmin'
  end

  test do
    system "#{bin}/jasmin", "-version"
  end
end
