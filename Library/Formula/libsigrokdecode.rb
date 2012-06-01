require 'formula'

class NeedsPython3 < Requirement
  def satisfied?
    is_python_version_3? || python3_found?
  end

  def fatal?
    true
  end

  def message; <<-EOS.undent
    This library depends on Python version 3.
    EOS
  end

private

  # check if default python command is version 3
  def is_python_version_3?
    return true if `python -c 'import sys;print(sys.version[:1])'`.to_i == 3
    return false
  end

  # check if python3 command is found in PATH
  def python3_found?
    ENV['PATH'].split(':').each do |path|
      return true if File.executable? "#{path}/python3"
    end
    return false
  end
end

class Libsigrokdecode < Formula
  homepage 'http://sigrok.org'
  url 'http://downloads.sourceforge.net/project/sigrok/source/libsigrokdecode/libsigrokdecode-0.1.0.tar.gz'
  md5 '9bc237972f6176ba9dcff057b4e85fd6'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  # libsigrokdecode needs python3!
  depends_on NeedsPython3.new

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
