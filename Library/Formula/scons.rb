require 'formula'

class Scons < Formula
  homepage 'http://www.scons.org'
  url 'https://downloads.sourceforge.net/scons/scons-2.3.0.tar.gz'
  sha1 '728edf20047a9f8a537107dbff8d8f803fd2d5e3'

  bottle do
    cellar :any
    revision 2
    sha1 "e1862648ffe4eb399716d692552659d37af16b3f" => :mavericks
    sha1 "b14e068dab8bdc866a622a340c1f48a2e87f1117" => :mountain_lion
    sha1 "41a6e453e87e6980cc59a7b29a49ef284baacada" => :lion
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
