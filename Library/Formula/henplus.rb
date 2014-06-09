require 'formula'

class Henplus < Formula
  homepage 'https://github.com/neurolabs/henplus'
  url 'https://github.com/downloads/neurolabs/henplus/henplus-0.9.8.tar.gz'
  sha1 'ab1fc3a2ec5a6c8f434d2965d9bbe2121030ffd1'

  depends_on :ant => :build
  depends_on 'libreadline-java'

  def install
    ENV['JAVA_HOME'] = `/usr/libexec/java_home`.chomp

    inreplace 'bin/henplus' do |s|
      s.gsub! "LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"
      s.gsub! "$THISDIR/..", HOMEBREW_PREFIX
      s.gsub! "share/java/libreadline-java.jar",
              "share/libreadline-java/libreadline-java.jar"
    end

    system 'ant', 'install', "-Dprefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    You may need to set JAVA_HOME:
      export JAVA_HOME="$(/usr/libexec/java_home)"
    EOS
  end

  test do
    system bin/"henplus", "--help"
  end
end
