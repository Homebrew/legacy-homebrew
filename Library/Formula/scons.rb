require 'formula'

class Scons < Formula
  homepage 'http://www.scons.org'
  url 'http://downloads.sourceforge.net/scons/scons-2.3.0.tar.gz'
  sha1 '728edf20047a9f8a537107dbff8d8f803fd2d5e3'

  bottle do
    sha1 "ba61be5122f1b4d918f50403dc68f27ee0b5e4d9" => :mavericks
    sha1 "35b7e5c98b133d28606eb4ca2afe11a5a5550fa2" => :mountain_lion
    sha1 "24c58992d86f2a4d618993d002bc266fc0e362e4" => :lion
  end

  def install
    bin.mkpath # Script won't create this if it doesn't already exist
    man1.install gzip('scons-time.1', 'scons.1', 'sconsign.1')
    system "/usr/bin/python", "setup.py", "install",
             "--prefix=#{prefix}",
             "--standalone-lib",
             # SCons gets handsy with sys.path---`scons-local` is one place it
             # will look when all is said and done.
             "--install-lib=#{libexec}/scons-local",
             "--install-scripts=#{bin}",
             "--install-data=#{libexec}",
             "--no-version-script", "--no-install-man"

    # Re-root scripts to libexec so they can import SCons and symlink back into
    # bin. Similar tactics are used in the duplicity formula.
    bin.children.each do |p|
      mv p, "#{libexec}/#{p.basename}.py"
      bin.install_symlink "#{libexec}/#{p.basename}.py" => p.basename
    end
  end
end
