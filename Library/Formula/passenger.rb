require 'formula'

class Passenger < Formula
  homepage 'https://www.phusionpassenger.com/'
  url 'http://s3.amazonaws.com/phusion-passenger/releases/passenger-4.0.49.tar.gz'
  sha1 'ef3916028b718903bb98712d99fb11c3dabf33c6'
  head 'https://github.com/phusion/passenger.git'

  bottle do
    sha1 "e4fe80a3f63f312cb87d6942e63beb9b57c35c8e" => :mavericks
    sha1 "5a91dc0fee1a99e548ad4f1102aa3531d9986777" => :mountain_lion
  end

  depends_on 'pcre'
  depends_on :macos => :mountain_lion

  option 'without-apache2-module', 'Disable Apache2 module'

  def install
    rake "apache2" if build.with? "apache2-module"
    rake "nginx"
    rake "webhelper"

    necessary_files = Dir[".editorconfig", "configure", "Rakefile", "README.md", "CONTRIBUTORS",
      "CONTRIBUTING.md", "LICENSE", "CHANGELOG", "INSTALL.md",
      "passenger.gemspec", "build", "lib", "node_lib", "bin", "doc", "man",
      "helper-scripts", "ext", "resources", "buildout"]
    libexec.mkpath
    cp_r necessary_files, libexec, :preserve => true

    # Allow Homebrew to create symlinks for the Phusion Passenger commands.
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Ensure that the Phusion Passenger commands can always find their library
    # files.
    locations_ini = `/usr/bin/ruby ./bin/passenger-config --make-locations-ini --for-native-packaging-method=homebrew`
    locations_ini.gsub!(/=#{Regexp.escape Dir.pwd}/, "=#{libexec}")
    (libexec/"lib/phusion_passenger/locations.ini").write(locations_ini)
    system "/usr/bin/ruby", "./dev/install_scripts_bootstrap_code.rb",
      "--ruby", libexec/"lib", *Dir[libexec/"bin/*"]
    system "/usr/bin/ruby", "./dev/install_scripts_bootstrap_code.rb",
      "--nginx-module-config", libexec/"bin", libexec/"ext/nginx/config"

    mv libexec/'man', share
  end

  def caveats
    s = <<-EOS.undent
      To activate Phusion Passenger for Nginx, run:
        brew install nginx --with-passenger

      EOS

    s += <<-EOS.undent if build.with? "apache2-module"
      To activate Phusion Passenger for Apache, create /etc/apache2/other/passenger.conf:
        LoadModule passenger_module #{opt_libexec}/buildout/apache2/mod_passenger.so
        PassengerRoot #{opt_libexec}/lib/phusion_passenger/locations.ini
        PassengerDefaultRuby /usr/bin/ruby

      EOS
    s
  end

  test do
    ruby_libdir = `#{HOMEBREW_PREFIX}/bin/passenger-config --ruby-libdir`.strip
    if ruby_libdir != (libexec/"lib").to_s
      raise "Invalid installation"
    end
  end
end
