require 'formula'

class BwmNg < Formula
  homepage 'http://www.gropp.org/?id=projects&sub=bwm-ng'
  url 'http://www.gropp.org/bwm-ng/bwm-ng-0.6.tar.gz'
  sha1 '90bab1837f179fa1fe0d4b8bad04072affa39c01'

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      Undefined symbols for architecture x86_64:
        "_dyn_byte_value2str", referenced from:
            _values2str in output.o
        "_get_iface_stats", referenced from:
            _main in bwm-ng.o
            _handle_gui_input in curses_tools.o
           (maybe you meant: _get_iface_stats_netstat, _get_iface_stats_sysctl , _get_iface_stats_getifaddrs )
     EOS
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
