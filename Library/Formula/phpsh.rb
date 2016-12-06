require 'formula'

class Phpsh <Formula
  url 'git://github.com/facebook/phpsh.git', :using => :git
  homepage 'http://phpsh.org/'
  version '1.2'

  depends_on 'python'
  depends_on 'readline'
  depends_on 'sqlite'

  depends_on 'sqlite3' => :python
  depends_on 'readline' => :python

  def install
    python = Formula.factory("python")
    system "#{python.bin}/python", "setup.py", "install",
              "--install-scripts", bin,
              "--install-purelib", python.site_packages,
              "--install-platlib", python.site_packages
  end
end
