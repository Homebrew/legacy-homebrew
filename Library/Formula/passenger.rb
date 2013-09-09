require 'formula'

class Passenger < Formula
  homepage 'https://www.phusionpassenger.com/'
  url 'http://s3.amazonaws.com/phusion-passenger/releases/passenger-4.0.16.tar.gz'
  sha1 '5594d425bfa2ee82afa049ed318890512ecea8f3'
  head 'https://github.com/phusion/passenger.git'

  depends_on 'curl'

  def install
    rake "apache2"
    rake "nginx"
    cp_r Dir["*"], prefix, :preserve => true

    # The various scripts in bin cannot correctly locate their root directory
    # when invoked as symlinks in /usr/local/bin. We create wrapper scripts
    # to solve this problem.
    mv bin, libexec
    mkdir bin
    Dir[libexec/"*"].each do |orig_script|
      name = File.basename(orig_script)
      (bin/name).write <<-EOS.undent
        #!/bin/sh
        exec #{orig_script} "$@"
      EOS
    end
    mv prefix/'man', share
  end

  def caveats; <<-EOS.undent
    To activate Phusion Passenger for Apache, create /etc/apache2/other/passenger.conf:
      LoadModule passenger_module #{opt_prefix}/libout/apache2/mod_passenger.so
      PassengerRoot #{opt_prefix}
      PassengerDefaultRuby /usr/bin/ruby

    To activate Phusion Passenger for Nginx, run:
      brew install nginx --with-passenger
    EOS
  end

  test do
    if `#{HOMEBREW_PREFIX}/bin/passenger-config --root`.strip != prefix.to_s
      raise "Invalid root path"
    end
  end
end
