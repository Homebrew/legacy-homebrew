module Homebrew extend self
  def diy
    %w[name version].each do |opt|
      if ARGV.include? "--set-#{opt}"
        opoo "--set-#{opt} is deprecated, please use --#{opt}=<#{opt}> instead"
      end
    end

    path = Pathname.getwd

    version = ARGV.value "version"
    version ||= if ARGV.include? "--set-version"
      ARGV.next
    elsif path.version.to_s.empty?
      raise "Couldn't determine version, set it with --version=<version>"
    else
      path.version
    end

    name = ARGV.value "name"
    name ||= if ARGV.include? "--set-name"
      ARGV.next
    else
      basename = path.basename.to_s
      basename[/(.*?)-?#{Regexp.escape(version)}/, 1] || basename
    end

    prefix = HOMEBREW_CELLAR/name/version

    if File.file? "CMakeLists.txt"
      puts "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    elsif File.file? "Makefile.am"
      puts "--prefix=#{prefix}"
    else
      raise "Couldn't determine build system"
    end
  end
end
