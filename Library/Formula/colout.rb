require 'formula'

class Colout < Formula
  homepage 'http://nojhan.github.io/colout/'
  url 'https://github.com/nojhan/colout.git', :revision => "d030cc9d3c62b34ce5c2522b3ffbdf1002355c08"
  head 'https://github.com/nojhan/colout.git'
  version '0.1'

  depends_on 'python3'

  def install
  	# https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python
    # In order to install into the Cellar, the dir must exist and be in the PYTHONPATH.
    temp_site_packages = lib/which_python/'site-packages'
    mkdir_p temp_site_packages
    ENV['PYTHONPATH'] = temp_site_packages
    
    args = [
      "--verbose",
      "install",
      "--force",
      "--install-scripts=#{bin}",
      "--install-lib=#{temp_site_packages}",
      "--install-data=#{share}",
      "--install-headers=#{include}",
    ]

    system "python3", "-s", "setup.py", *args
  end

  def which_python
  	# https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python
    # Update this once we have something like [this](https://github.com/mxcl/homebrew/issues/11204)
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

end
