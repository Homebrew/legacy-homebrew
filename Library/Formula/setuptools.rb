require 'formula'

class Setuptools <Formula
  url 'http://pypi.python.org/packages/source/s/setuptools/setuptools-0.6c11.tar.gz'
  homepage 'http://pypi.python.org/pypi/setuptools'
  md5 '7df2a529a074f613b509fb44feefe74e'
  version '0.6c11'

  def install
    dest=prefix+'lib/setuptools'
    FileUtils.mkdir_p dest
    ENV.append 'PYTHONPATH', dest, ":"
    system "python", "setup.py", "install", "--prefix=#{prefix}", "--install-lib=#{dest}"

    site_packages = `python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"`.chomp
    pth = Pathname.new site_packages+'/homebrew.pth'
    ohai "Writing #{pth} to enable setuptools"
    data = DATA.read
    data.sub! "HOMEBREW_SETUPTOOLS_PATH", dest
    pth.unlink if pth.exist?
    pth.write data
  end
end

__END__
# Please dont't modify this file, Homebrew will overwrite it.
import site; site.addsitedir('HOMEBREW_SETUPTOOLS_PATH')
