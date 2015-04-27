require 'formula'

class Ranger < Formula
  homepage 'http://ranger.nongnu.org/'
  url 'http://ranger.nongnu.org/ranger-1.7.0.tar.gz'
  sha1 '2bc30b305fab527f0f1e8c9b6ba03fac18d5c6a7'

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
