require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class SphinxPython < Formula
  homepage 'http://sphinx.pocoo.org/'
  url 'http://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.1.3.tar.gz'
  md5 '8f55a6d4f87fc6d528120c5d1f983e98'

  def install
    dir="#{prefix}/#{site_package_dir}"
    ENV["PYTHONPATH"] = "#{dir}:" + ENV["PYTHONPATH"]
    mkdir_p dir
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
Sphinx Python modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH.
    EOS
  end
end
