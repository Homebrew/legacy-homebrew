require 'formula'

class V8cgi < Formula
  homepage 'http://code.google.com/p/v8cgi/'
  url 'http://v8cgi.googlecode.com/files/v8cgi-0.9.3-src.tar.gz'
  sha1 'a3dd4a648bce71aa3cb37ba2c1921f0605ff50f0'

  head 'http://v8cgi.googlecode.com/svn/trunk/'

  option "with-dom", "Enable DOM"

  depends_on 'scons' => :build
  depends_on 'v8'
  depends_on 'libmemcached'
  depends_on 'xerces-c' if build.with? 'dom'
  depends_on 'gd' => :optional
  depends_on 'sqlite' => :optional

  def install
    arch = Hardware.is_64_bit? ? 'x64' : 'ia32'

    v8_prefix = Formula.factory('v8').prefix

    args = ["config_file=#{etc}/v8cgi.conf", "v8_path=#{v8_prefix}"]
    args << ((build.with? 'dom') ? 'dom=1' : 'dom=0')
    args << ((build.with? 'gd') ? 'gd=1' : 'gd=0')
    args << ((build.with? 'sqlite') ? 'sqlite=1' : 'sqlite=0')

    cd 'v8cgi' do
      inreplace 'SConstruct', '../v8', v8_prefix

      system "scons",
             "-j #{ENV.make_jobs}",
             "arch=#{arch}",
             "library=shared",
             "socket=1",
             "process=1",
             "cgi=1",
             "mysql=0",
             "gl=0",
             "module=0",
             *args

      bin.install 'v8cgi'
      lib.install 'lib' => 'v8cgi'
      etc.install 'v8cgi.conf.darwin' => 'v8cgi.conf'
    end
  end
end
