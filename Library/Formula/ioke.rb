require 'formula'

class Ioke < Formula
  homepage 'http://ioke.org/'
  url 'http://ioke.org/dist/ioke-P-ikj-0.4.0.tar.gz'
  sha1 '1cf1512e1a845b64c8f839fed396f279afdc0ed9'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles

    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    # Point IOKE_HOME to libexec
    inreplace libexec/'bin/ioke' do |s|
      s.change_make_var! 'IOKE_HOME', libexec
    end

    bin.install_symlink libexec/'bin/ioke'
  end
end
