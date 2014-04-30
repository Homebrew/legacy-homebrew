require 'formula'

class CocaineCore < Formula
  homepage 'https://github.com/cocaine/cocaine-core'
  url 'https://github.com/cocaine/cocaine-core', :using => :git, :tag => '0.11.2.0'
  sha1 'd045c8586a435e1bb29a3405f43cddc0e651a119'

  depends_on 'cmake' => :build
  depends_on 'boost' => 'c++11'
  depends_on 'libarchive'
  depends_on 'libev'
  depends_on 'libtool' => :build
  depends_on 'msgpack'

  def install
    cmake_args = std_cmake_args
    cmake_args << '-DCMAKE_CXX_FLAGS=-std=c++11'
    cmake_args << '-DCMAKE_CXX_FLAGS=-stdlib=libc++'
    system 'cmake', '.', *cmake_args
    system 'make', 'install'
  end

  test do
    config = %Q(
    {
      "version": 2,
      "paths": {
        "plugins": "#{testpath}/usr/lib/cocaine",
        "runtime": "#{testpath}/var/run/cocaine"
      },
      "storages": {
        "core": {
          "type": "files",
          "args": {
              "path": "#{testpath}/var/lib/cocaine"
          }
        }
      },
      "loggers": {
        "core": {
          "type": "files",
          "args": {
            "path": "/dev/stdout",
            "verbosity": "debug",
            "port": 50030
          }
        }
      }
    })
    (testpath/'default.json').write(config)
    system "mkdir -p #{testpath}/usr/lib/cocaine"
    system "mkdir -p #{testpath}/var/run/cocaine"
    system "mkdir -p #{testpath}/var/lib/cocaine"

    system "cat #{testpath}/default.json"
    system "#{bin}/cocaine-runtime --version"

    pid = Process.fork
    if pid.nil?
      puts 'Starting cocaine-runtime (timeout: 1s) ...'
      exec "#{bin}/cocaine-runtime --configuration #{testpath}/default.json"
    else
      Process.detach pid
      sleep 1
      puts "Terminating cocaine-runtime (pid: #{pid}) ..."
      Process.kill 'TERM', pid
      Process.wait
    end
  end
end
