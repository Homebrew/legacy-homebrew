require 'formula'

class Passenger < Formula
  homepage 'https://www.phusionpassenger.com/'
  url 'http://s3.amazonaws.com/phusion-passenger/releases/passenger-4.0.38.tar.gz'
  sha1 'c1e80c27b3f1c43d91dbd239ddecd4b81e6c13bd'
  head 'https://github.com/phusion/passenger.git'

  bottle do
    sha1 "363ea4bcfede79fcc2eb13eb13d7110ba6fb15ce" => :mavericks
    sha1 "1a85e572065bdf3eaa2bc16dc0db615b220c81be" => :mountain_lion
    sha1 "8b14e945b72d4de6c9866041fb6ecf9e37a9b4ae" => :lion
  end

  depends_on 'pcre'
  depends_on :macos => :lion

  def install
    rake "apache2"
    rake "nginx"
    rake "webhelper"

    necessary_files = Dir["configure", "Rakefile", "README.md", "CONTRIBUTORS",
      "CONTRIBUTING.md", "LICENSE", "CHANGELOG", "INSTALL.md",
      "passenger.gemspec", "build", "lib", "node_lib", "bin", "doc", "man",
      "helper-scripts", "ext", "resources", "buildout"]
    libexec.mkpath
    cp_r necessary_files, libexec, :preserve => true

    # Allow Homebrew to create symlinks for the Phusion Passenger commands.
    bin.mkpath
    Dir[libexec/"bin/*"].each do |orig_script|
      name = File.basename(orig_script)
      ln_s orig_script, bin/name
    end

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

  def caveats; <<-EOS.undent
    To activate Phusion Passenger for Apache, create /etc/apache2/other/passenger.conf:
      LoadModule passenger_module #{opt_libexec}/buildout/apache2/mod_passenger.so
      PassengerRoot #{opt_libexec}/lib/phusion_passenger/locations.ini
      PassengerDefaultRuby /usr/bin/ruby

    To activate Phusion Passenger for Nginx, run:
      brew install nginx --with-passenger
    EOS
  end

  test do
    ruby_libdir = `#{HOMEBREW_PREFIX}/bin/passenger-config --ruby-libdir`.strip
    if ruby_libdir != (libexec/"lib").to_s
      raise "Invalid installation"
    end
  end
end
