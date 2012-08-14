require 'formula'

class Scons < Formula
  url 'http://downloads.sourceforge.net/project/scons/scons/2.1.0/scons-2.1.0.tar.gz'
  homepage 'http://www.scons.org'
  md5 '47daf989e303a045b76c11236df719df'

  def install
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
