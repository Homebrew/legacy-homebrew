require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Pyzmq < Formula
  homepage 'Python bindings for 0MQ'
  url 'http://pypi.python.org/packages/source/p/pyzmq/pyzmq-2.2.0.tar.gz'
  sha1 '2f46525886ff3d6148f83f900986cc2a0cb598a1'

  depends_on 'zeromq'

  def install
    system "python setup.py config"
    system "python setup.py build"
    system "python setup.py install --prefix=#{prefix}"
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def site_package_dir
    "lib/#{which_python}/site-packages"
  end

  def caveats
    <<-EOS
Python bindings for 0MP modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH.
    EOS
  end

end
