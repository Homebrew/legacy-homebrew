require 'formula'

class ShadowsocksLibev < Formula
  homepage 'https://github.com/madeye/shadowsocks-libev'
  url 'https://github.com/madeye/shadowsocks-libev.git', :using => :git, :revision => '7288df7c844f837f9d943b8abc4e660396e7f0ef'
  version '1.2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
   Run
        ss-local -s server_host -p server_port -l local_port -k password
        [-m encrypt_method] [-f pid_file] [-t timeout] [-c config_file]
   options:
        encrypt_method:         table, rc4
        pid_file:               valid path to the pid file
        timeout:                socket timeout in senconds
        config_file:            json format config file
    EOS
    end

  test do
    <<-eos
    system `#{bin}/ss-server`
    eos
  end
end
