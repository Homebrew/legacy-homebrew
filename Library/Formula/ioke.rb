require 'formula'

class Ioke < Formula
  url 'http://ioke.org/dist/ioke-P-ikj-0.4.0.tar.gz'
  homepage 'http://ioke.org/'
  md5 '936fac215d14809ff5f4bd1fd8262ce0'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Point IOKE_HOME to libexec
    inreplace 'bin/ioke' do |s|
      s.change_make_var! 'IOKE_HOME', libexec
    end

    # Install jars in libexec to avoid conflicts
    prefix.install %w{ COPYING LICENSE README bin }
    libexec.install Dir['*']
  end
end
