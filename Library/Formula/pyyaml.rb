require 'formula'

class Pyyaml < Formula
  homepage 'http://pyyaml.org/wiki/PyYAML'
  url 'http://pyyaml.org/download/pyyaml/PyYAML-3.10.tar.gz'
  sha1 '476dcfbcc6f4ebf3c06186229e8e2bd7d7b20e73'

  depends_on 'libyaml'

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
PyYAML Python modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH.
    EOS
  end
end
