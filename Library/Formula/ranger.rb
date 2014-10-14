require 'formula'

class Ranger < Formula
  homepage 'http://ranger.nongnu.org/'
  url 'http://nongnu.org/ranger/ranger-1.6.1.tar.gz'
  sha1 'ac66644b362c6ed5b6f2127af799e12d8993f3b8'

  head 'git://git.savannah.nongnu.org/ranger.git'

  # requires 2.6 or newer; Leopard comes with 2.5
  depends_on :python if MacOS.version <= :leopard

  def install
    inreplace %w[ranger.py ranger/ext/rifle.py] do |s|
      s.gsub! "#!/usr/bin/python", "#!#{PythonDependency.new.which_python}"
    end if MacOS.version <= :leopard

    man1.install 'doc/ranger.1'
    libexec.install 'ranger.py', 'ranger'
    bin.install_symlink libexec+'ranger.py' => 'ranger'
  end
end
