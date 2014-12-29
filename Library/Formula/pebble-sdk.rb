require 'formula'

class PebbleSdk < Formula
  homepage 'https://developer.getpebble.com/2/'
  url 'http://assets.getpebble.com.s3-website-us-east-1.amazonaws.com/sdk2/PebbleSDK-2.8.1.tar.gz'
  sha1 'b96d158fda8b9846d8a1e994a5dc0760412fe8d7'

  bottle do
    revision 1
    sha1 "b6fdf398ba146ca097add357b91bc230228532ab" => :yosemite
    sha1 "47f18c0fa6ac2f133e9d1ad12dc1b864f906dad9" => :mavericks
    sha1 "477f1ca4ea4df085e6490d952b7928312002979e" => :mountain_lion
  end

  depends_on :macos => :mountain_lion
  depends_on 'freetype' => :recommended
  depends_on 'mpfr' => :build
  depends_on 'gmp' => :build
  depends_on 'libmpc' => :build
  depends_on 'libelf' => :build
  depends_on 'texinfo' => :build

  # List of resources can be obtained from requirements.txt
  resource 'freetype-py' do
    url 'https://pypi.python.org/packages/source/f/freetype-py/freetype-py-1.0.tar.gz'
    sha1 '3830e45ff9e9a96f1e209d786cbd5492f168127a'
  end

  resource 'sh' do
    url 'https://pypi.python.org/packages/source/s/sh/sh-1.08.tar.gz'
    sha1 '85ca7f0fd69af238cdca94aa3a87f050ad7b11e9'
  end

  resource 'twisted' do
    url 'https://pypi.python.org/packages/source/T/Twisted/Twisted-12.0.0.tar.bz2'
    sha1 '64b7f7fdeefbd4dd8e6bdffb12d9095106ee3d5d'
  end

  resource 'autobahn' do
    url 'https://pypi.python.org/packages/source/a/autobahn/autobahn-0.5.14.zip'
    sha1 '475ba5f281bdcc50858c6920c034a1a067b2ce2a'
  end

  resource 'websocket-client' do
    url 'https://pypi.python.org/packages/source/w/websocket-client/websocket-client-0.12.0.tar.gz'
    sha1 '2c132d1a185ea55bfccde734507158fefc336f91'
  end

  resource 'pyserial' do
    url 'https://pypi.python.org/packages/source/p/pyserial/pyserial-2.7.tar.gz'
    sha1 'f15694b1bea9e4369c1931dc5cf09e37e5c562cf'
  end

  resource 'pypng' do
    url 'https://pypi.python.org/packages/source/p/pypng/pypng-0.0.16.tar.gz'
    sha1 'f90a1f88a7875f019b1fc0addde5410ce6daf2dd'
  end

  resource 'pebble-arm-toolchain' do
    url 'https://github.com/pebble/arm-eabi-toolchain/archive/v2.0.tar.gz'
    sha1 '7085c6ef371213e3e766a1cbd7e6e1951ccf1d87'
  end

  def install
    inreplace 'bin/pebble' do |s|
      # This replacement fixes a path that gets messed up because of the
      # bin.env_script_all_files call (which relocates actual pebble.py script
      # to libexec/, causing problems with the absolute path expected below).
      s.gsub! /^script_path = .*?$/m, "script_path = '#{libexec}/../tools/pebble.py'"

      # This replacement removes environment settings that were needed only
      # if installation was done with the official script
      s.gsub! /^local_python_env.*?=.*?\(.*?\)$/m, ""
      s.gsub! /^process = subprocess\.Popen\(args, shell=False, env=local_python_env\)/, "process = subprocess.Popen(args, shell=False)"
    end

    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    resource('freetype-py').stage { system "python", *install_args }
    resource('sh').stage { system "python", *install_args }
    resource('twisted').stage { system "python", *install_args }
    resource('autobahn').stage { system "python", *install_args }
    resource('websocket-client').stage { system "python", *install_args }
    resource('pyserial').stage { system "python", *install_args }
    resource('pypng').stage { system "python", *install_args }

    rm_rf "Examples/.git"
    doc.install %w[Documentation Examples README.txt]
    prefix.install %w[Pebble bin tools requirements.txt version.txt]

    resource('pebble-arm-toolchain').stage do
      system "make", "PREFIX=#{prefix}/arm-cs-tools", "install-cross"
    end

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system bin/'pebble', 'new-project', 'test'
    cd 'test' do
      # We have to remove the default /usr/local/include from the CPATH
      # because the toolchain has -Werror=poison-system-directories set
      ENV['CPATH'] = ''
      system bin/'pebble', 'build'
    end
  end

  def caveats; <<-EOS.undent
    Documentation and examples can be found in
      #{doc}
    EOS
  end
end

