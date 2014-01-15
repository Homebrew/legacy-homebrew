require 'formula'

class Crash < Formula
  homepage 'http://www.crashub.org/'
  url 'https://crsh.googlecode.com/files/crash-1.2.8.tar.gz'
  sha1 '12290cd227b20eae07674f8cf0d43ee58732e34b'

  devel do
    url 'https://crsh.googlecode.com/files/crash-1.3.0-beta13.tar.gz'
    sha1 '4012ff4cc751a261ebfadf01f3b9441b275844a8'

    resource 'docs' do
      url 'https://crsh.googlecode.com/files/crash-1.3.0-beta13-docs.tar.gz'
      sha1 '5b0e6da691662a5344ad0029de457297fdcc1df8'
    end
  end

  resource 'docs' do
    url 'https://crsh.googlecode.com/files/crash-1.2.8-docs.tar.gz'
    sha1 'ea385cf28c9c8fc0512d8809bf511c37a5be8e1a'
  end

  def install
    doc.install resource('docs')
    libexec.install Dir['crash/*']
    bin.install_symlink "#{libexec}/bin/crash.sh"
  end
end
